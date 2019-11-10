MC = Application("Menubar Countdown")

MC.activate()

MC.showStartDialog()

MC.hours = 99
MC.minutes = 59
MC.seconds = 59

MC.blink = false
MC.playAlertSound = false
MC.repeatAlertSound = false
MC.showAlertWindow = false
MC.showNotification = false
MC.playNotificationSound = false
MC.speakAnnouncement = false

MC.announcementText = "The checkboxes should all be off now."

MC.displaySeconds = false
MC.showStartDialogOnLaunch = false

delay(2)

MC.hours = 0
MC.minutes = 25
MC.seconds = 0

MC.blink = true
MC.playAlertSound = true
MC.repeatAlertSound = true
MC.showAlertWindow = true
MC.showNotification = true
MC.playNotificationSound = true
MC.speakAnnouncement = true

MC.announcementText = "The checkboxes should all be on now."

MC.displaySeconds = true
MC.showStartDialogOnLaunch = true
