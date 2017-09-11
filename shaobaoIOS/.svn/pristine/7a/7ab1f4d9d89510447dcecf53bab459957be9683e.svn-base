//
//  ADTGovermentFileInfo.h
//  officeMobile
//
//  Created by Points on 15-3-11.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

typedef enum FileStatue
{
    enum_comleted   = 10,
    enum_processing = 20,
    enum_waiting    = 30,
    enum_supend     = 40
}
enum_File_Statue;

typedef enum FieldType
{
    enum_inter   = 10,
    enum_string  = 30,
    enum_date    = 20,
    enum_opinion  =31,
    enum_content  =80,
    enum_file     =81,
    enum_other     =90,
    enum_investigate     =99,
}
enum_Field_Type;

typedef enum FileType
{
    enum_normal         = 1,
    enum_instruction    = 3,
    enum_sign           = 7,
}
enum_File_Type;

#import <Foundation/Foundation.h>

@interface ADTFormInfo : NSObject

@property(nonatomic,strong)NSString *m_strFieldName;
@property(nonatomic,strong)NSString *m_strFieldChineseName;
@property(nonatomic,assign)enum_Field_Type m_filedType;
@property(nonatomic,strong)NSString *m_strFieldValue;
@property(nonatomic,assign)BOOL m_isCanEdit;
@property(nonatomic,assign)BOOL m_isHidden;
@property(nonatomic,strong)NSMutableArray *m_arrCatelogList;
@end

@interface ADTAttachmentInfo : NSObject

@property(nonatomic,strong)NSString *m_strFileName;
@property(nonatomic,strong)NSString * m_strFilleType;
@property(nonatomic,strong)NSString *m_docType;
@property(nonatomic,strong)NSString *m_strFileId;
@property(nonatomic,strong)NSString  *m_strFileBody;
@property(nonatomic,strong)NSString  *m_strRecordId;

@end

@interface ADTMainBodyInfo : NSObject

@property(nonatomic,strong)NSString *m_strFileName;
@property(nonatomic,strong)NSString *m_strFilleType;
@property(nonatomic,strong)NSString *m_strDocType;
@property(nonatomic,strong)NSString *m_strFileId;
@property(nonatomic,strong)NSString  *m_strFileBody;
@property(nonatomic,strong)NSString  *m_strRecordId;

@end

@interface ADTProcessData : NSObject

@property(nonatomic,strong)NSString *m_strProcessTime;
@property(nonatomic,strong)NSString *m_strProcesser;
@property(nonatomic,strong)NSString *m_strNodeName;
@property(nonatomic,strong)NSString *m_strStatus;
@property(nonatomic,strong)NSString  *m_strOpinion;

@end

@interface ADTCommitButtonInfo : NSObject

@property(nonatomic,strong)NSString *m_strFlowModelId;
@property(nonatomic,strong)NSString *m_strNodeModelId;
@property(nonatomic,strong)NSString *m_strActionId;
@property(nonatomic,strong)NSString *m_strActionName;
@end

@interface ADTCheckInfo : NSObject

@property(nonatomic,strong)NSString *m_strProcesser;
@property(nonatomic,strong)NSString *m_strProcessTime;
@property(nonatomic,strong)NSString *m_strStatus;
@property(nonatomic,strong)NSString *m_strNodename;
@property(nonatomic,strong)NSString *m_strOpinion;
@end

@interface ADTGovermentFileInfo : NSObject

@property(nonatomic,strong)NSString *m_strFlowId;
@property(nonatomic,strong)NSString *m_strMessageId;
@property(nonatomic,strong)NSString *m_strFlowModelId;
@property(nonatomic,strong)NSString *m_strNodemodelId;
@property(nonatomic,strong)NSString *m_strNodeName;
@property(nonatomic,strong)NSString *m_strReceiverId;//innerid
@property(nonatomic,strong)NSString *m_strInnerid;
@property(nonatomic,assign)BOOL m_isReadOnly;
@property(nonatomic,assign)BOOL m_isHandSign;

@property(nonatomic,strong)NSString *m_strSubject;
@property(nonatomic,assign)enum_File_Statue m_fileState;
@property(nonatomic,assign)BOOL m_isCanBack;
@property(nonatomic,assign)BOOL m_isCanPass;
@property(nonatomic,assign)enum_File_Statue m_flowState;
@property(nonatomic,strong)NSArray *m_arrNextButton;
@property(nonatomic,strong)NSArray *m_arrFlowLog;
@property(nonatomic,strong)NSArray *m_arrForm;
@property(nonatomic,strong)NSArray *m_arrDocument;
@property(nonatomic,strong)NSArray *m_arrAttachment;
@property(nonatomic,strong)NSString *m_strOption;

@property(nonatomic,strong)NSArray *m_arrOriginalForm;
@property(nonatomic,strong)NSMutableArray *m_arrOriginalFormForFaultRepair;
@property(nonatomic,strong)NSArray *m_arrOriginalAccessory;
@property(nonatomic,strong)NSArray *m_arrReadInfo;
@property(nonatomic,strong)NSMutableArray *m_arrCatalogList;

+(ADTGovermentFileInfo *)getInfoFrom:(NSDictionary *)infoDic;





@end
