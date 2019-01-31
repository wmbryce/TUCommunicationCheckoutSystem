//
//  UgiTag.h
//
//  Copyright (c) 2012 U Grok It. All rights reserved.
//

#define __UGI_TAG_H

#import <Foundation/Foundation.h>

#import "UgiEpc.h"

@class UgiTagReadState;   // forward reference
@class UgiInventory;   // forward reference

///////////////////////////////////////////////////////////////////////////////////////
// Enums must be defined outside the class for Swift, but inside the class for
// Doxygen (the documentation generator)
///////////////////////////////////////////////////////////////////////////////////////

typedef NS_ENUM(int, UgiHfTagTypes) {
  UGI_HF_TAG_ISO_15693 = 1,
  UGI_HF_TAG_ISO_14443A = 2,
  UGI_HF_TAG_TOPAZ = 3,
  UGI_HF_TAG_FELICA = 4
};

///////////////////////////////////////////////////////////////////////////////////////
// End enums
///////////////////////////////////////////////////////////////////////////////////////

/**
 A tag found by the reader: an EPC and additional data. This object will change if the
 tag's EPC is changed or its memory is written
 */
@interface UgiTag : NSObject

#if DOXYGEN   // Defined before class for Swift compatibility, documented here for Doxygen compatibility

/**
 HF tag types
 */
typedef enum {
  UGI_HF_TAG_ISO_15693 = 1,   //! ISO 15693 tag
  UGI_HF_TAG_ISO_14443A = 2,  //! ISO 14443A tag
  UGI_HF_TAG_TOPAZ = 3,       //! Topaz tag
  UGI_HF_TAG_FELICA = 4       //! Felica tag
} UgiHfTagTypes;

#endif
///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties
///////////////////////////////////////////////////////////////////////////////////////

//! Tag's EPC
@property (readonly, nonatomic, nonnull) UgiEpc *epc;

//! When this tag was first read
@property (readonly, nonatomic, nonnull) NSDate *firstRead;

//! TID memory
@property (retain, nonatomic, nullable) NSData *tidMemory;

//! USER memory
@property (retain, nonatomic, nullable) NSData *userMemory;

//! RESERVED memory
@property (readonly, nonatomic, nullable) NSData *reservedMemory;

//! Type of HF tag
@property (readonly, nonatomic) UgiHfTagTypes hfTagType;

//! HF tag: name (not localized)
@property (readonly, nonatomic, nonnull) NSString *hfName;

//! HF tag: short description (not localized)
@property (readonly, nonatomic, nonnull) NSString *hfShortDescription;

//! HF tag: long description (not localized)
@property (readonly, nonatomic, nonnull) NSString *hfLongDescription;

//! For ISO 15693 tag: DSFID
@property (readonly, nonatomic) int hfIso15693dsfid;

//! For ISO 15693 tag: AFI
@property (readonly, nonatomic) int hfIso15693afi;

//! For ISO 15693 tag: information flags
@property (readonly, nonatomic) int hfIso15693infoFlags;

//! For ISO 15693 tag: IC reference
@property (readonly, nonatomic) int hfIso15693icReference;

//! For ISO 15693 tag: number of memory blocks
@property (readonly, nonatomic) int hfIso15693numBlocks;

//! For ISO 15693 tag: memory block size
@property (readonly, nonatomic) int hfIso15693blockSize;

//! For ISO 14443A tag: ATQA
@property (readonly, nonatomic) int hfIso14443Aatqa;

//! For ISO 14443A tag: SAK (note that only the first byte may be valid, depending on tag type)
@property (readonly, nonatomic) int hfIso14443Asak;

//! For ISO 14443A tag: memory size
@property (readonly, nonatomic) int hfIso14443AmemorySize;

//! For Topaz tag: ATQA
@property (readonly, nonatomic) int hfTopazAtqa;

//! For Topaz tag: HR
@property (readonly, nonatomic) int hfTopazHr;

//! For FeliCA tag: IC Code
@property (readonly, nonatomic) int hfFelicaIcCode;

//! For FeliCA tag: System Code
@property (readonly, nonatomic) int hfFelicaSystemCode;

//! Read state for this tag at this moment in time
@property (readonly, nonatomic, nonnull) UgiTagReadState *readState;

//! YES if the tag is visible (as defined in UgiTagReadState). This is a convenience equivalent to getReadState.isVisible)
@property (readonly, nonatomic) BOOL isVisible;

//! Inventory this tag is associated with
@property (readonly, nonatomic, nonnull) UgiInventory *inventory;

@end
