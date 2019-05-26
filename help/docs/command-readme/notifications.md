### Notifications using Pushbullet or Pushover

#### For Pushbullet services

If you don't have an account go make one here [https://www.pushbullet.com/](https://www.pushbullet.com/)

Then you need to visit this URL to generate an API key: [https://www.pushbullet.com/#settings/account](https://www.pushbullet.com/#settings/account)

![pushbullet-api](../readme-images/pushbullet-api.jpg)

#### For Pushover services

If you don't have an account go make one here: [https://pushover.net/login](https://pushover.net/login)

Then you need to visit this URL to create a new application to generate an API key: [https://pushover.net/apps/build](https://pushover.net/apps/build)

![pushover-api-key](../readme-images/pushover-api.jpg)

You can find your user key here: [https://pushover.net/](https://pushover.net/)

![pushover-user-key](../readme-images/pushover-user-key.jpg)

Once you have created an account with either or both services you need to use the `notifications` custom command in a WinSCP session to enter and save your API details.

![pushbullet-api-key](../readme-images/pushbullet-api-key.jpg)

Once you have done that you will get a Pushbullet or Pushover notification to your devices when either a mirror, pget or sync task completes.