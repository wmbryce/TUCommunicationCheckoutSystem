//
//  Ugi_firmwareUpdate.h
//
//  Copyright (c) 2012 U Grok It. All rights reserved.
//

#import "Ugi.h"

#define __UGI_FIRMWARE_UPDATE_H

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////////
// Enums must be defined outside the class for Swift, but inside the class for
// Doxygen (the documentation generator)
///////////////////////////////////////////////////////////////////////////////////////

typedef NS_ENUM(int, UgiFirmwareUpdateCompatibilityValues) {
  FIRMWARE_COMPATIBILITY_INVALID = 0,
  FIRMWARE_COMPATIBILITY_INCOMPATIBLE = 1,
  FIRMWARE_COMPATIBILITY_DOWNGRADE = 2,
  FIRMWARE_COMPATIBILITY_SAME_VERSION = 3,
  FIRMWARE_COMPATIBILITY_UPGRADE = 4
};

typedef NS_ENUM(NSUInteger, UgiFirmwareUpdateReturnValues) {
  UGI_FIRMWARE_UPDATE_SUCCESS = 0,
  UGI_FIRMWARE_UPDATE_NO_FILE = 100,
  UGI_FIRMWARE_UPDATE_BAD_FILE = 101,
  UGI_FIRMWARE_UPDATE_INCOMPATIBLE_HARDWARE = 102,
  UGI_FIRMWARE_UPDATE_INCOMPATIBLE_VERSION = 103,
  UGI_FIRMWARE_UPDATE_CRC_MISMATCH = 3,
  UGI_FIRMWARE_UPDATE_PROTOCOL_FAILURE = 104,
  UGI_FIRMWARE_UPDATE_CANT_RECONNECT = 105,
  UGI_FIRMWARE_UPDATE_CANCELLED = 106,
  UGI_FIRMWARE_UPDATE_BATTERY_TOO_LOW = 107
};

///////////////////////////////////////////////////////////////////////////////////////
// End enums
///////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UgiFirmwareUpdateInfo
///////////////////////////////////////////////////////////////////////////////////////

/**
 A UgiFirmwareUpdateInfo object contains information about a single firmware update
 available via an update channel.
 */
@interface UgiFirmwareUpdateInfo : NSObject

#if DOXYGEN   // Defined before class for Swift compatibility, documented here for Doxygen compatibility
              //! Values returned from firmwareCheckCompatibility
typedef enum {
  FIRMWARE_COMPATIBILITY_INVALID = 0,        //!< File is invalid
  FIRMWARE_COMPATIBILITY_INCOMPATIBLE = 1,   //!< File is incompatible with this Grokker
  FIRMWARE_COMPATIBILITY_DOWNGRADE = 2,      //!< File is older than the firmware on this Grokker
  FIRMWARE_COMPATIBILITY_SAME_VERSION = 3,   //!< File is the same as the firmware on this Grokker
  FIRMWARE_COMPATIBILITY_UPGRADE = 4         //!< File is newer than the firmware on this Grokker
} UgiFirmwareUpdateCompatibilityValues;
#endif

@property (readonly, retain, nonatomic, nonnull) NSString *name;            //!< Name of update file
@property (readonly) int protocol;                                 //!< Reader protocol
@property (readonly, retain, nonatomic, nonnull) NSString *notes;           //!< Notes

@property (readonly, nonatomic) UgiFirmwareUpdateCompatibilityValues compatibilityValue;   //!< Compatibility
@property (readonly, nonatomic) int softwareVersionMajor;        //!< Version major
@property (readonly, nonatomic) int softwareVersionMinor;        //!< Version minor
@property (readonly, nonatomic) int softwareVersionBuild;        //!< Version build
@property (readonly, nonatomic, retain, nonnull) NSDate *sofwareVersionDate;    //!< Date the firmware ware built

//! @cond false 
- (BOOL) hasReaderSerialNumbers;
//! @endcond

@property (readonly, retain, nonatomic, nonnull) NSString *hfName;          //!< Name of HF update file
@property (readonly, nonatomic) int hfVersionMajor;        //!< Version major
@property (readonly, nonatomic) int hfVersionMinor;        //!< Version minor
@property (readonly, nonatomic) int hfVersionBuild;        //!< Version build
@property (readonly, nonatomic, retain, nonnull) NSDate *hfVersionDate;    //!< Date the firmware ware built

@end

/**
 Firmware update portion of Ugi interface
 */
@interface Ugi ()

/**
 * Name of release channel
 */
@property (readonly, nonatomic, nonnull) NSString *FIRMWARE_CHANNEL_RELEASE;

/**
 * Name of development channel
 */
@property (readonly, nonatomic, nonnull) NSString *FIRMWARE_CHANNEL_DEVELOPMENT;

/**
 * Name of channel for automatic updates (normally FIRMWARE_CHANNEL_RELEASE)
 */
@property (nonatomic, nonnull) NSString *automaticFirmwareUpdateChannel;

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Automatic update
///////////////////////////////////////////////////////////////////////////////////////

/**
 If an automatic firmware update is available, reprompt for it (via the configuration delegate)
 */
- (void) repromptForAutomaticFirmwareUpdateIfAvailable;

/**
 Completion type for checkForUpdateOnConnect
 @param info         Info for update that is ready (or nil if update cannot be loaded)
 @param required     YES if update is required
 */
typedef void (^AutomaticCheckForFirmwareUpdateCompletion)(UgiFirmwareUpdateInfo * _Nullable info,
                                                          BOOL required);

/**
 Check for firmware update automatically.
 The channel data is reloaded:
 - when forceFirmwareChannelReload: is called
 - on UIApplicationDidBecomeActiveNotification
 - once a day
 The Grokker is checked for needing to be updated:
 - each time a Grokker is connected
 - whenever new channel data is loaded (and a Grokker is connected and not running inventory)
 - when forceFirmwareGrokkerCheck: is called
 It is possible that a firmware update is available at a time that is inconveient for an update.

 @param completion  Completion code when an update is ready
 */
- (void) automaticCheckForFirmwareUpdateWithCompletion:(nonnull AutomaticCheckForFirmwareUpdateCompletion)completion;

/**
 Update the firmware update status (reload the control file).
 @param onlyIfSomeTimeHasPassed     YES to only force the check if time has passed since the last check
 */
- (void) forceFirmwareChannelReload:(BOOL)onlyIfSomeTimeHasPassed;

/**
 Check the grokker for firmware update
 @return YES if a firmware update was initiated
 */
- (BOOL) forceFirmwareGrokkerCheck;

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Advanced options
///////////////////////////////////////////////////////////////////////////////////////

/**
 Load an update. The update is loaded into a file in the _UGrokItSDK directory
 Calback is called with YES if the update loaded successfully
 @param name Update to load
 @param hfName HF update to load
 @param completion  Completion called after the update has been loaded
 */
- (void)loadUpdateWithName:(NSString * _Nonnull)name
                withHfName:(NSString * _Nullable)hfName
            withCompletion:(nonnull void(^)(NSError * _Nullable error))completion;

/**
 Cancel an update in progress
 */
- (void) cancelFirmwareUpdate;

/**
 Load updates (metadata)
 @param channel   Channel to load from, normally FIRMWARE_CHANNEL_RELEASE
 @param checkCompatibilityWithConnectedGrokker  YES to check compatibility
 @param completion  Completion code when updates are loaded
 */
- (void) loadUpdatesFromChannel:(NSString * _Nonnull)channel
         withCheckCompatibility:(BOOL)checkCompatibilityWithConnectedGrokker
                 withCompletion:(nonnull void(^)(NSMutableArray<UgiFirmwareUpdateInfo *> * _Nullable updates))completion;

/**
 After firmware has been updated, update an array of UgiFirmwareUpdateInfo objects
 @param updates   Updates to update
 */
- (void) updateFirmwareInfoCompatibility:(NSMutableArray * _Nonnull)updates;

/**
 See if an update is in progress
 @return    YES if an update is in progress
 */
- (BOOL)isUpdateInProgress;

/**
 See if an update is required
 @return    YES if an update is required
 */
- (BOOL)isUpdateRequired;

/**
 Set that this app requires a minimum firmware version on the Grokker
 @param firmwareVersion    The minimum firmware version
 */
- (void)requiresFirmwareVersion:(NSString * _Nullable)firmwareVersion;

/**
 Function definition for completion for firmwareUpdate
 */
typedef void (^FirmwareUpdateProgressCompletion)(int amountDone, int amountTotal, BOOL canCancel);

/**
 Function definition for completion for firmwareUpdate
 */
typedef void (^FirmwareUpdateCompletion)(UgiFirmwareUpdateReturnValues result, int seconds);

/**
 Update firmware that has been previously loaded with loadUpdateWithName:

 @param allowDowngrade   YES to allow downgrading
 @param progressCompletion    Code to run preiodically to update status
 @param completion    Code to run when done
 */
- (void) firmwareUpdateWithAllowDowngrade:(BOOL)allowDowngrade
                   withProgressCompletion:(nonnull FirmwareUpdateProgressCompletion)progressCompletion
                           withCompletion:(nonnull FirmwareUpdateCompletion)completion;

//! DEBUGGING - cause the firmware update code to update to the previous version
// of the formware. This enables repoeated testing of the firmware update code, which
// is useful for applications that override some of the default firmware update functionality.
@property (nonatomic) BOOL debug_forceFirmwareUpdateToPreviousVersion;

@end
