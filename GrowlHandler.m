//
//  GrowlHandler.m
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

#import "GrowlHandler.h"


NSString *GrowlHandlerTimerExpiredNotificationWasClicked = @"GrowlHandlerTimerExpiredNotificationWasClicked";


@implementation GrowlHandler


- (id)init {
    applicationName = NSLocalizedString(@"Menubar Countdown",
                                        @"Growl Application Name");
    [applicationName retain];

    timerExpiredNotification = NSLocalizedString(@"Timer expired",
                                                 @"Growl Timer Expired Notification");
    [timerExpiredNotification retain];

    return self;
}


- (void)dealloc {
    [GrowlApplicationBridge setGrowlDelegate:nil];
    [timerExpiredNotification release];
    [applicationName release];
    [super dealloc];
}


- (void)connectToGrowl {
    [GrowlApplicationBridge setGrowlDelegate:self];
}


- (void)notifyTimerExpired:(NSString *)announcementText {
    [GrowlApplicationBridge notifyWithTitle:timerExpiredNotification
                                description:announcementText
                           notificationName:timerExpiredNotification
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:timerExpiredNotification];
}


- (NSDictionary *)registrationDictionaryForGrowl {
    NSArray *notifications = [NSArray arrayWithObject:timerExpiredNotification];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          notifications, GROWL_NOTIFICATIONS_ALL,
                          notifications, GROWL_NOTIFICATIONS_DEFAULT,
                          nil];
    return dict;
}


- (NSString *)applicationNameForGrowl {
    return applicationName;
}


- (void)growlNotificationWasClicked:(id)clickContext {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:GrowlHandlerTimerExpiredNotificationWasClicked
                      object:clickContext];
}


- (void)growlNotificationTimedOut:(id)clickContext {
    NSLog(@"Growl notification timed out");
}

@end
