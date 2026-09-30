# Firebase Setup Guide

## 1. Create Firebase Project

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project**
3. Name: `onenews-firebase`
4. Disable Google Analytics (optional)
5. Click **Create project**

## 2. Add Android App

1. In Firebase console, click the **Android icon** (</>)
2. Package name: `com.onenews.app`
3. App nickname: `OneNews`
4. Click **Register app**
5. Download `google-services.json`
6. Place it in `android/app/google-services.json`
7. Click **Next** through the remaining steps

## 3. Enable Cloud Messaging

1. In Firebase console, go to **Build** → **Cloud Messaging**
2. Click **Create your first notification** (or skip)
3. Note your **Server key** from **Project settings** → **Cloud Messaging**

## 4. Configure Flutter

Add to `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        applicationId "com.onenews.app"
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:33.6.0')
    implementation 'com.google.firebase:firebase-messaging'
}
```

Add to `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

Add to `android/app/build.gradle` (at the bottom):
```gradle
apply plugin: 'com.google.gms.google-services'
```

## 5. Set FCM Server Key in Supabase

```bash
supabase secrets set FCM_SERVER_KEY=your-server-key
```

## 6. Test Push Notifications

1. Run the app
2. Check console for FCM token
3. Send test message from Firebase console → **Cloud Messaging** → **New notification**

## Free Tier

| Resource | Limit |
|---|---|
| Notifications | Unlimited |
| Topics | Unlimited |
| Data messages | Unlimited |

Firebase Cloud Messaging is completely free.
