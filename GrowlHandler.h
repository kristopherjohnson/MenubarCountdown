//
//  GrowlHandler.h
//  MenuTimer
//
//  Created by Kristopher Johnson on 6/5/09.
//  Copyright 2009 Capable Hands Technologies, Inc.. All rights reserved.
//
//  This file is part of Menubar Countdown.
//
//  Menubar Countdown is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Menubar Countdown is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Menubar Countdown.  If not, see <http://www.gnu.org/licenses/>.

#import <Cocoa/Cocoa.h>
#import "Growl.framework/Headers/GrowlApplicationBridge.h"

/// \brief Notification posted when Growl notification is clicked
extern NSString* GrowlHandlerTimerExpiredNotificationWasClicked;

/// \brief Provides application-specific wrapper for the Growl application bridge
@interface GrowlHandler : NSObject <GrowlApplicationBridgeDelegate> {
    NSString* applicationName;           ///< Application name reported to Growl
    NSString* timerExpiredNotification;  ///< Name and title for "Timer expired" Growl notification
}

/// \brief Set Growl application bridge delegate to this object
- (void)connectToGrowl;

/// \brief Send Growl notification that timer has expired
- (void)notifyTimerExpired:(NSString *)announcementText;

@end
