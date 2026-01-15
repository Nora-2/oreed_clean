import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/networking/firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for managing Firebase Cloud Messaging notifications
/// Handles subscriptions, local notifications, and message processing
///
/// **Usage Example:**
/// ```dart
/// // In your main.dart, set the global navigator key first
/// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Set the navigator key for immediate notification navigation
///   NotificationService.setNavigatorKey(navigatorKey);
///
///   // Initialize notification service
///   await NotificationService().initNotification();
///
///   runApp(MyApp(navigatorKey: navigatorKey));
/// }
///
/// // In your MyApp widget, use the navigator key
/// class MyApp extends StatelessWidget {
///   final GlobalKey<NavigatorState> navigatorKey;
///
///   const MyApp({required this.navigatorKey});
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       navigatorKey: navigatorKey,
///       // ... rest of your app
///     );
///   }
/// }
///
/// // Set optional callback for custom navigation handling
/// NotificationService.setOnNotificationAction((context, data) {
///   // Handle notification action with BuildContext
/// });
///
/// // Execute pending notifications when app starts (in HomePage)
/// @override
/// void initState() {
///   super.initState();
///   WidgetsBinding.instance.addPostFrameCallback((_) {
///     NotificationService.executePendingNotificationNavigation(context);
///   });
/// }
///
/// // Subscribe to user-specific topics
/// await NotificationService().subscribeToUserTypeTopic('personal');
/// ```
///
/// **Notification Types Supported:**
/// - `personal`: Navigate to ad details (requires: ad_id, section_id)
/// - `company`: Navigate to company details (requires: company_id, section_id)
/// - `phone`: Initiate phone call (requires: phone)
class NotificationService {
  // ==================== Constants ====================

  /// FCM topic names
  static const String defaultTopic = 'oreedo';
  static const String personalTopic = 'oreedo_personal';
  static const String businessTopic = 'oreedo_business';

  /// Android notification channel configuration
  static const String _channelId = 'default_channel';
  static const String _channelName = 'General Notifications';
  static const String _channelDescription =
      'Channel for general app notifications';

  /// SharedPreferences keys for tracking topic subscriptions
  static const String _kSubscribedToDefault = 'subscribed_to_default_topic';
  static const String _kSubscribedToPersonal = 'subscribed_to_personal_topic';
  static const String _kSubscribedToBusiness = 'subscribed_to_business_topic';

  /// Enable/disable verbose logging
  static const bool _enableVerboseLogging = true;

  /// Retry configuration
  static const int _maxRetries = 3;
  static const int _retryBaseDelaySeconds = 2;

  // ==================== Instance Variables ====================

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AppSharedPreferences _prefs = AppSharedPreferences();

  /// Store received messages for history (optional)
  final List<RemoteMessage> notificationMessages = [];

  // Flag to guard background isolate local notifications initialization
  static bool _backgroundPluginInitialized = false;

  /// Callback for notification actions (navigation, etc.)
  static void Function(BuildContext context, Map<String, dynamic> data)?
  _onNotificationAction;

  /// Global navigation key for accessing BuildContext from anywhere
  static GlobalKey<NavigatorState>? _navigatorKey;

  // ==================== Singleton Pattern ====================

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  /// Set the callback for notification actions (navigation, calls, etc.)
  static void setOnNotificationAction(
    void Function(BuildContext context, Map<String, dynamic> data) callback,
  ) {
    _onNotificationAction = callback;
  }

  /// Set the global navigator key for navigation from anywhere
  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  // ==================== Initialization ====================

  /// Initialize the notification service
  /// Call this once at app startup
  Future<void> initNotification() async {
    try {
      await _initializeFirebase();
      await _requestPermissions();
      await _initializeLocalNotifications();
      await _ensureAndroidChannel();
      await _setupMessageHandlers();
      await _handleInitialMessage();
      await subscribeToDefaultTopic();

      _log('✅ Notification service initialized successfully');
      await printSubscriptionStatus();
    } catch (e, stackTrace) {
      _logError('Failed to initialize notification service', e, stackTrace);
    }
  }

  /// Initialize Firebase
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      _log('⚠️ Firebase already initialized or failed: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true,
      );

      _log(
        '📱 Notification permission status: ${settings.authorizationStatus}',
      );

      // iOS specific: Set foreground presentation options
      if (Platform.isIOS) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e, stackTrace) {
      _logError('Failed to request permissions', e, stackTrace);
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _log('✅ Local notifications plugin initialized with tap handler');
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    _log('📲 Notification tapped with payload: ${response.payload}');
    _handleNotificationTap(response.payload);
  }

  /// Setup Firebase message handlers
  Future<void> _setupMessageHandlers() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/terminated app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Handle initial message when app was terminated
  Future<void> _handleInitialMessage() async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _logMessage(initialMessage, stage: 'initial/terminated');
        // Store initial message to handle navigation once BuildContext is available
        _handleMessageData(initialMessage.data);
      }
    } catch (e, stackTrace) {
      _logError('Failed to get initial message', e, stackTrace);
    }
  }

  // ==================== Message Handlers ====================

  /// Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    _logMessage(message, stage: 'foreground');
    notificationMessages.add(message);
    _showNotification(message);
  }

  /// Handle message when app opened from background
  void _handleMessageOpenedApp(RemoteMessage message) {
    _logMessage(message, stage: 'opened_from_background');
    _handleMessageData(message.data);
  }

  /// Process message data and trigger appropriate action
  void _handleMessageData(Map<String, dynamic> data) {
    try {
      _log('🔄 Processing notification data: ${jsonEncode(data)}');

      final notificationType = data['type'] as String?;

      if (notificationType == null) {
        _log('⚠️ Notification type not specified in data');
        return;
      }

      // Call the registered callback if available
      // Note: The callback needs to be called with a valid BuildContext
      // This will be handled by the app's main navigation logic
      _triggerNotificationAction(notificationType, data);
    } catch (e, stackTrace) {
      _logError('Failed to process message data', e, stackTrace);
    }
  }

  /// Trigger notification action based on type
  void _triggerNotificationAction(String type, Map<String, dynamic> data) {
    switch (type.toLowerCase()) {
      case 'personal':
        _log('👤 Handling personal ad notification');
        _handlePersonalAdNotification(data);
        break;
      case 'company':
        _log('🏢 Handling company notification');
        _handleCompanyNotification(data);
        break;
      case 'phone':
        _log('📞 Handling phone call notification');
        _handlePhoneNotification(data);
        break;
      default:
        _log('⚠️ Unknown notification type: $type');
    }
  }

  /// Handle personal ad notification - navigate to ad details
  void _handlePersonalAdNotification(Map<String, dynamic> data) {
    try {
      final adId = data['ad_id'] as String?;
      final sectionId = data['section_id'] as String?;

      if (adId == null || sectionId == null) {
        _log('⚠️ Missing ad_id or section_id for personal notification');
        return;
      }

      _log('📂 Personal Ad - ID: $adId, Section: $sectionId');

      // Store navigation data to be processed when BuildContext is available
      _storeNavigationData({
        'action': 'navigate_to_ad_details',
        'ad_id': adId,
        'section_id': sectionId,
        'data': data,
      });
    } catch (e, stackTrace) {
      _logError('Failed to handle personal ad notification', e, stackTrace);
    }
  }

  /// Handle company notification - navigate to company details
  void _handleCompanyNotification(Map<String, dynamic> data) {
    try {
      final String? companyId = data['company_id'] as String?;
      final String? sectionId = data['section_id'] as String?;

      if (companyId == null) {
        _log('⚠️ Missing company_id for company notification');
        return;
      }

      _log('🏢 Company - ID: $companyId, Section: $sectionId');

      // Store navigation data to be processed when BuildContext is available
      _storeNavigationData({
        'action': 'navigate_to_company_details',
        'company_id': companyId,
        'section_id': sectionId,
        'data': data,
      });
    } catch (e, stackTrace) {
      _logError('Failed to handle company notification', e, stackTrace);
    }
  }

  /// Handle phone notification - initiate phone call
  void _handlePhoneNotification(Map<String, dynamic> data) {
    try {
      final phone = data['phone'] as String?;

      if (phone == null || phone.isEmpty) {
        _log('⚠️ Missing or empty phone number');
        return;
      }

      _log('📞 Calling: $phone');

      // Store navigation data to trigger call
      _storeNavigationData({
        'action': 'call_phone',
        'phone': phone,
        'data': data,
      });
    } catch (e, stackTrace) {
      _logError('Failed to handle phone notification', e, stackTrace);
    }
  }

  // ==================== Navigation Helpers ====================

  /// Store navigation data to be processed when BuildContext is available
  Future<void> _storeNavigationData(Map<String, dynamic> navigationData) async {
    _log('💾 Storing navigation data: $navigationData');
    try {
      await _prefs.initSharedPreferencesProp();
      await _prefs.setString(
        'pending_notification_navigation',
        jsonEncode(navigationData),
      );
      _log('✅ Navigation data stored successfully');
    } catch (e) {
      _logError('Failed to store navigation data', e);
    }
  }

  /// Handle notification tap from local notification
  void _handleNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) {
      _log('⚠️ Empty notification payload');
      return;
    }

    _log('📲 Notification tapped with payload: $payload');

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final notificationType = data['type'] as String?;

      if (notificationType != null) {
        _log('🔔 Notification type: $notificationType');
        _log('📦 Full data: ${jsonEncode(data)}');

        // Try to execute navigation immediately if BuildContext is available
        final context = _navigatorKey?.currentContext;
        if (context != null) {
          _log('✅ BuildContext available, executing navigation immediately');
          _handleMessageData(data);
          _executeImmediateNavigation(context, data);
        } else {
          _log(
            '⚠️ No BuildContext available, storing navigation data for later',
          );
          // Store navigation data for processing when BuildContext becomes available
          _handleMessageData(data);
        }
      } else {
        _log('⚠️ No notification type found in payload');
      }
    } catch (e) {
      _log('⚠️ Failed to parse notification payload: $e');
      // If payload is not JSON, try to use it directly
      _storeNavigationData({'payload': payload});
    }
  }

  /// Execute navigation immediately when BuildContext is available
  Future<void> _executeImmediateNavigation(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      final notificationType = data['type'] as String?;

      if (notificationType == null) {
        _log('⚠️ No notification type found');
        return;
      }

      // Clear any pending navigation data since we're executing immediately
      try {
        await _prefs.initSharedPreferencesProp();
        await _prefs.setString('pending_notification_navigation', '');
        _log('✅ Cleared pending notification data (immediate execution)');
      } catch (clearError) {
        _logError('Failed to clear pending notification', clearError);
      }

      // Call the registered callback if available
      if (_onNotificationAction != null) {
        _onNotificationAction!(context, data);
        return;
      }

      // Fallback to default navigation
      switch (notificationType.toLowerCase()) {
        case 'personal':
          final adId = data['ad_id'] as String?;
          final sectionId = data['section_id'] as String?;
          if (adId != null && sectionId != null) {
            _log(
              '📂 Navigating to ad details - ID: $adId, Section: $sectionId',
            );

            Navigator.of(context).pushNamed(
              Routes.addetails,
              arguments: {
                'sectionId': int.tryParse(sectionId) ?? 0,
                'adId': int.tryParse(adId) ?? 0,
              },
            );
          }
          break;

        case 'company':
          final companyId = data['company_id'] as String?;
          final sectionId = data['section_id'] as String?;
          if (companyId != null) {
            _log('🏢 Navigating to company details - ID: $companyId');

            Navigator.of(context).pushNamed(
              Routes.companydetails,
              arguments: {
                'sectionId': sectionId != null ? int.tryParse(sectionId) : null,
                'companyId': int.tryParse(companyId) ?? 0,
              },
            );
          }
          break;

        case 'phone':
          final phone = data['phone'] as String?;
          if (phone != null && phone.isNotEmpty) {
            _log('📞 Initiating call to: $phone');
            final uri = Uri(scheme: 'tel', path: phone);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              _log('✅ Phone call initiated');
            }
          }
          break;

        default:
          _log('⚠️ Unknown notification type: $notificationType');
      }
    } catch (e, stackTrace) {
      _logError('Failed to execute immediate navigation', e, stackTrace);
    }
  }

  /// Execute pending notification navigation with BuildContext
  /// Call this from your app's main page or router
  static Future<void> executePendingNotificationNavigation(
    BuildContext context,
  ) async {
    try {
      final service = NotificationService();
      await service._prefs.initSharedPreferencesProp();

      final pendingData = service._prefs.getString(
        'pending_notification_navigation',
      );

      if (pendingData == null || pendingData.isEmpty) {
        service._log('ℹ️ No pending notification navigation');
        return;
      }

      service._log('🚀 Executing pending notification navigation');

      final navigationData = jsonDecode(pendingData) as Map<String, dynamic>;
      final action = navigationData['action'] as String?;
      final data = navigationData['data'] as Map<String, dynamic>? ?? {};

      // Clear the stored data before execution
      try {
        await service._prefs.setString('pending_notification_navigation', '');
        service._log('✅ Cleared pending notification data');
      } catch (clearError) {
        service._logError('Failed to clear pending notification', clearError);
      }

      // Execute the appropriate navigation
      if (_onNotificationAction != null) {
        _onNotificationAction!(context, data);
      } else {
        // Fallback navigation if callback not set
        await _executeNotificationNavigation(context, action, data);
      }
    } catch (e, stackTrace) {
      NotificationService._instance._logError(
        'Failed to execute pending notification',
        e,
        stackTrace,
      );
    }
  }

  /// Default notification navigation handler
  static Future<void> _executeNotificationNavigation(
    BuildContext context,
    String? action,
    Map<String, dynamic> data,
  ) async {
    if (action == null) {
      NotificationService._instance._log(
        '⚠️ No action specified for navigation',
      );
      return;
    }

    switch (action) {
      case 'navigate_to_ad_details':
        final adId = data['ad_id'] as String?;
        final sectionId = data['section_id'] as String?;

        if (adId != null && sectionId != null) {
          NotificationService._instance._log(
            '📂 Navigating to ad details - ID: $adId, Section: $sectionId',
          );
          try {
            Navigator.of(context).pushNamed(
              Routes.addetails,
              arguments: {
                'sectionId': int.tryParse(sectionId) ?? 0,
                'adId': int.tryParse(adId) ?? 0,
              },
            );
          } catch (e) {
            NotificationService._instance._logError(
              'Failed to navigate to ad details',
              e,
            );
          }
        } else {
          NotificationService._instance._log(
            '⚠️ Missing ad_id or section_id for navigation',
          );
        }
        break;

      case 'navigate_to_company_details':
        final companyId = data['company_id'] as String?;
        final sectionId = data['section_id'] as String?;

        if (companyId != null) {
          NotificationService._instance._log(
            '🏢 Navigating to company details - ID: $companyId, Section: $sectionId',
          );
          try {
            Navigator.of(context).pushNamed(
              Routes.companydetails,
              arguments: {
                'sectionId': sectionId,
                'companyId': sectionId != null ? int.tryParse(sectionId) : null,
              },
            );
          } catch (e) {
            NotificationService._instance._logError(
              'Failed to navigate to company details',
              e,
            );
          }
        } else {
          NotificationService._instance._log(
            '⚠️ Missing company_id for navigation',
          );
        }
        break;

      case 'call_phone':
        final phone = data['phone'] as String?;
        if (phone != null && phone.isNotEmpty) {
          NotificationService._instance._log('📞 Initiating call to: $phone');
          try {
            final uri = Uri(scheme: 'tel', path: phone);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              NotificationService._instance._log('✅ Phone call initiated');
            } else {
              NotificationService._instance._log(
                '❌ Could not launch phone call for: $phone',
              );
            }
          } catch (e) {
            NotificationService._instance._logError(
              'Failed to initiate phone call',
              e,
            );
          }
        } else {
          NotificationService._instance._log(
            '⚠️ Missing or empty phone number',
          );
        }
        break;

      default:
        NotificationService._instance._log('⚠️ Unknown action: $action');
    }
  }

  // ==================== Logging ====================

  /// Log a message (if verbose logging enabled)
  void _log(String message) {
    if (_enableVerboseLogging) {
      print(message);
    }
  }

  /// Log an error with stack trace
  void _logError(String message, Object error, [StackTrace? stackTrace]) {
    print('❌ $message: $error');
    if (_enableVerboseLogging && stackTrace != null) {
      print(stackTrace);
    }
  }

  /// Pretty log full RemoteMessage contents
  void _logMessage(RemoteMessage message, {String stage = 'foreground'}) {
    if (!_enableVerboseLogging) return;

    try {
      final buffer = StringBuffer()
        ..writeln('=' * 60)
        ..writeln('FCM MESSAGE [$stage]')
        ..writeln('=' * 60)
        ..writeln('📧 Message ID: ${message.messageId ?? 'N/A'}')
        ..writeln('📤 From: ${message.from ?? 'N/A'}')
        ..writeln('📁 Category: ${message.category ?? 'N/A'}')
        ..writeln('🔑 Collapse Key: ${message.collapseKey ?? 'N/A'}')
        ..writeln('⏰ Sent Time: ${message.sentTime ?? 'N/A'}')
        ..writeln('⏳ TTL: ${message.ttl ?? 'N/A'}')
        ..writeln('📬 Content Available: ${message.contentAvailable}')
        ..writeln('🔄 Mutable Content: ${message.mutableContent}')
        ..writeln('📦 Data (${message.data.length} items):')
        ..writeln('   ${jsonEncode(message.data)}');

      final notification = message.notification;
      if (notification != null) {
        buffer
          ..writeln('🔔 Notification:')
          ..writeln('   Title: ${notification.title ?? 'N/A'}')
          ..writeln('   Body: ${notification.body ?? 'N/A'}')
          ..writeln(
            '   Android Image: ${notification.android?.imageUrl ?? 'N/A'}',
          )
          ..writeln(
            '   iOS Subtitle: ${notification.apple?.subtitle ?? 'N/A'}',
          );
      } else {
        buffer.writeln('🔔 Notification: None');
      }

      buffer.writeln('=' * 60);
      print(buffer.toString());
    } catch (e) {
      _log('⚠️ Failed to log message: $e');
    }
  }

  // ==================== Topic Subscription Management ====================

  /// Get the SharedPreferences key for a topic
  String? _getKeyForTopic(String topic) {
    switch (topic) {
      case defaultTopic:
        return _kSubscribedToDefault;
      case personalTopic:
        return _kSubscribedToPersonal;
      case businessTopic:
        return _kSubscribedToBusiness;
      default:
        return null;
    }
  }

  /// Check if subscribed to a specific topic
  Future<bool> isSubscribedToTopic(String topic) async {
    try {
      await _prefs.initSharedPreferencesProp();
      final key = _getKeyForTopic(topic);
      if (key == null) return false;
      return _prefs.getBool(key, defaultValue: false);
    } catch (e) {
      _logError('Failed to check subscription for topic: $topic', e);
      return false;
    }
  }

  /// Save subscription status for a topic
  Future<void> _saveSubscriptionStatus(String topic, bool subscribed) async {
    try {
      await _prefs.initSharedPreferencesProp();
      final key = _getKeyForTopic(topic);
      if (key == null) return;
      await _prefs.setBool(key, subscribed);
    } catch (e) {
      _logError('Failed to save subscription status for topic: $topic', e);
    }
  }

  /// Print all subscription statuses
  Future<void> printSubscriptionStatus() async {
    if (!_enableVerboseLogging) return;

    try {
      final defaultStatus = await isSubscribedToTopic(defaultTopic);
      final personalStatus = await isSubscribedToTopic(personalTopic);
      final businessStatus = await isSubscribedToTopic(businessTopic);

      print('=' * 55);
      print('TOPIC SUBSCRIPTION STATUS');
      print('=' * 55);
      print(
        '📌 $defaultTopic: ${defaultStatus ? "✅ Subscribed" : "❌ Not Subscribed"}',
      );
      print(
        '📌 $personalTopic: ${personalStatus ? "✅ Subscribed" : "❌ Not Subscribed"}',
      );
      print(
        '📌 $businessTopic: ${businessStatus ? "✅ Subscribed" : "❌ Not Subscribed"}',
      );
      print('=' * 55);
    } catch (e) {
      _logError('Failed to print subscription status', e);
    }
  }

  /// Subscribe to default topic for all users
  Future<void> subscribeToDefaultTopic() async {
    await _subscribeWithRetry(defaultTopic);
  }

  /// Subscribe to user-type-specific topic
  /// [userType]: 'personal' or 'office' (business)
  Future<void> subscribeToUserTypeTopic(String userType) async {
    final topic = userType == 'personal' ? personalTopic : businessTopic;
    await _subscribeWithRetry(topic);
  }

  /// Subscribe to a topic with retry logic and exponential backoff
  Future<void> _subscribeWithRetry(
    String topic, {
    int maxRetries = _maxRetries,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await _firebaseMessaging.subscribeToTopic(topic);
        await _saveSubscriptionStatus(topic, true);
        _log('🔔 Subscribed to topic: $topic');
        await printSubscriptionStatus();
        return;
      } catch (e) {
        _log(
          '❌ Failed to subscribe to topic $topic (attempt $attempt/$maxRetries): $e',
        );

        if (attempt < maxRetries) {
          // Exponential backoff
          final delaySeconds = _retryBaseDelaySeconds * attempt;
          _log('⏳ Retrying in $delaySeconds seconds...');
          await Future.delayed(Duration(seconds: delaySeconds));
        }
      }
    }

    _log('⚠️ Could not subscribe to topic $topic after $maxRetries attempts');
  }

  /// Unsubscribe from default topic
  Future<void> unsubscribeFromDefaultTopic() async {
    await _unsubscribeFromTopic(defaultTopic);
  }

  /// Unsubscribe from user-type-specific topic
  /// [userType]: 'personal' or 'office' (business)
  Future<void> unsubscribeFromUserTypeTopic(String userType) async {
    final topic = userType == 'personal' ? personalTopic : businessTopic;
    await _unsubscribeFromTopic(topic);
  }

  /// Unsubscribe from a specific topic
  Future<void> _unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      await _saveSubscriptionStatus(topic, false);
      _log('🔕 Unsubscribed from topic: $topic');
      await printSubscriptionStatus();
    } catch (e, stackTrace) {
      _logError('Failed to unsubscribe from topic: $topic', e, stackTrace);
    }
  }

  /// Unsubscribe from all user-type topics
  /// Useful when switching user type or logging out
  Future<void> unsubscribeFromAllUserTypeTopics() async {
    await Future.wait([
      _unsubscribeFromTopic(personalTopic),
      _unsubscribeFromTopic(businessTopic),
    ]);
    _log('🔕 Unsubscribed from all user-type topics');
  }

  // ==================== Android Channel Setup ====================

  /// Ensure Android notification channel is created
  Future<void> _ensureAndroidChannel() async {
    if (!Platform.isAndroid) return;

    try {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      _log('✅ Android notification channel created');
    } catch (e, stackTrace) {
      _logError('Failed to create Android notification channel', e, stackTrace);
    }
  }

  // ==================== Notification Display ====================

  /// Show a local notification from a remote message
  Future<void> _showNotification(RemoteMessage message) async {
    try {
      final localizedContent = _getLocalizedContent(message);
      final imageUrl = _extractImageUrl(message);

      if (_enableVerboseLogging) {
        _log('📱 Showing notification:');
        _log('   Language: ${_prefs.languageCode ?? 'ar'}');
        _log('   Title: ${localizedContent.title}');
        _log('   Body: ${localizedContent.body}');
        if (imageUrl != null) _log('   Image: $imageUrl');
      }

      final androidDetails = await _buildAndroidNotificationDetails(
        localizedContent,
        imageUrl,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Encode the entire message data as payload for navigation
      final payload = jsonEncode(message.data);

      await _flutterLocalNotificationsPlugin.show(
        message.hashCode,
        localizedContent.title,
        localizedContent.body,
        platformDetails,
        payload: payload,
      );
    } catch (e, stackTrace) {
      _logError('Failed to show notification', e, stackTrace);
    }
  }

  /// Get localized notification content based on app language
  _LocalizedContent _getLocalizedContent(RemoteMessage message) {
    final lang = (_prefs.languageCode ?? 'ar').toLowerCase();
    final data = message.data;
    final notification = message.notification;

    // Extract all possible title/body variations
    final titleAr = data['title_ar'] ?? data['titleAr'];
    final titleEn = data['title_en'] ?? data['titleEn'];
    final bodyAr = data['body_ar'] ?? data['bodyAr'];
    final bodyEn = data['body_en'] ?? data['bodyEn'];
    final genericTitle = data['title'];
    final genericBody = data['body'];

    // Resolve based on language preference
    final title = lang == 'ar'
        ? _firstNonEmpty([titleAr, genericTitle, titleEn, notification?.title])
        : _firstNonEmpty([titleEn, genericTitle, titleAr, notification?.title]);

    final body = lang == 'ar'
        ? _firstNonEmpty([bodyAr, genericBody, bodyEn, notification?.body])
        : _firstNonEmpty([bodyEn, genericBody, bodyAr, notification?.body]);

    return _LocalizedContent(title: title, body: body);
  }

  /// Extract image URL from message data or notification
  String? _extractImageUrl(RemoteMessage message) {
    final data = message.data;
    return data['image'] ??
        data['imageUrl'] ??
        data['image_url'] ??
        message.notification?.android?.imageUrl;
  }

  /// Build Android notification details with optional image
  Future<AndroidNotificationDetails> _buildAndroidNotificationDetails(
    _LocalizedContent content,
    String? imageUrl,
  ) async {
    BigPictureStyleInformation? bigPictureStyle;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final imagePath = await _downloadAndCacheImage(imageUrl);
        final bigPicture = FilePathAndroidBitmap(imagePath);

        bigPictureStyle = BigPictureStyleInformation(
          bigPicture,
          contentTitle: content.title,
          summaryText: content.body,
          largeIcon: bigPicture,
        );
      } catch (e) {
        _log('⚠️ Failed to load notification image: $e');
      }
    }

    return AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      styleInformation: bigPictureStyle,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );
  }

  /// Download and cache an image for notification display
  Future<String> _downloadAndCacheImage(String url) async {
    try {
      // Validate URL
      if (url.isEmpty) {
        throw Exception('Empty image URL');
      }

      // Parse and validate URI
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        throw Exception('Invalid image URL: $url');
      }

      final directory = await getTemporaryDirectory();
      final fileName = 'notif_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory.path}/$fileName';

      // Download with timeout and proper error handling
      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Image download timeout'),
          );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download image: HTTP ${response.statusCode}',
        );
      }

      if (response.bodyBytes.isEmpty) {
        throw Exception('Downloaded image is empty');
      }

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      _log('✅ Cached notification image: $filePath');

      return filePath;
    } catch (e) {
      _logError('Failed to download and cache image', e);
      rethrow;
    }
  }

  /// Helper: return first non-null, non-empty string from list
  String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;
      final str = value.toString().trim();
      if (str.isNotEmpty) return str;
    }
    return '';
  }

  // ==================== FCM Token Management ====================

  /// Get and log FCM token
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      _log('🔐 FCM Token: $token');

      // iOS specific: log APNS token
      if (_enableVerboseLogging && Platform.isIOS) {
        try {
          final apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken != null) {
            _log('🔐 APNS Token (iOS): $apnsToken');
          }
        } catch (_) {
          // Ignore APNS token errors
        }
      }

      return token;
    } catch (e, stackTrace) {
      _logError('Failed to get FCM token', e, stackTrace);

      // Retry after delay
      Future.delayed(const Duration(seconds: 5), () async {
        try {
          final token = await _firebaseMessaging.getToken();
          _log('🔐 FCM Token (retry): $token');
        } catch (retryError) {
          _log('⚠️ Failed to get FCM token on retry: $retryError');
        }
      });

      return null;
    }
  }

  /// Listen for FCM token refresh
  void listenToTokenRefresh(void Function(String token) onTokenRefresh) {
    _firebaseMessaging.onTokenRefresh.listen(
      (newToken) {
        _log('🔄 FCM Token refreshed: $newToken');
        onTokenRefresh(newToken);
      },
      onError: (error) {
        _logError('FCM token refresh error', error);
      },
    );
  }

  // ==================== Background Safe Init ====================
  /// Ensure local notifications plugin & channel are initialized in a background isolate.
  /// This is needed for data-only FCM messages when the app is in background/terminated.
  Future<void> _ensureBackgroundInitialization() async {
    if (_backgroundPluginInitialized) return;
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize with tap handler for background notifications
      await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      await _ensureAndroidChannel();
      _backgroundPluginInitialized = true;
      _log('✅ Background notification plugin initialized with tap handler');
    } catch (e, stackTrace) {
      _logError('Failed background notification init', e, stackTrace);
    }
  }

  /// Public helper used by top-level background handler to show a notification with localization.
  static Future<void> showBackgroundNotification(RemoteMessage message) async {
    final service = NotificationService();
    await service._ensureBackgroundInitialization();
    // Reuse localization logic
    final localizedContent = service._getLocalizedContent(message);

    // Build minimal Android details (avoid heavy image processing in background)
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      // Encode the entire message data as payload for navigation
      final payload = jsonEncode(message.data);

      await service._flutterLocalNotificationsPlugin.show(
        message.hashCode,
        localizedContent.title.isEmpty ? ' ' : localizedContent.title,
        localizedContent.body.isEmpty ? ' ' : localizedContent.body,
        platformDetails,
        payload: payload,
      );
      service._log('🌙 Background notification shown (id=${message.hashCode})');
    } catch (e, stackTrace) {
      service._logError(
        'Failed to show background notification',
        e,
        stackTrace,
      );
    }
  }
}

// ==================== Background Message Handler ====================

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final messageData = {
      'messageId': message.messageId,
      'from': message.from,
      'sentTime': message.sentTime?.toIso8601String(),
      'data': message.data,
      'notification': {
        'title': message.notification?.title,
        'body': message.notification?.body,
        'imageUrl': message.notification?.android?.imageUrl,
      },
    };

    print('🌙 Background FCM message received:');
    print(jsonEncode(messageData));

    // Attempt to show a local notification for data-only or any incoming message
    await NotificationService.showBackgroundNotification(message);
  } catch (e, stackTrace) {
    print('❌ Background message handler error: $e');
    print(stackTrace);
  }
}

// ==================== Helper Classes ====================

/// Helper class to hold localized notification content
class _LocalizedContent {
  final String title;
  final String body;

  const _LocalizedContent({required this.title, required this.body});
}
