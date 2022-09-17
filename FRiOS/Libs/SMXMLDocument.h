#import <Foundation/Foundation.h>

// SMXMLDocument is a very handy lightweight XML parser for iOS.

extern NSString *const SMXMLDocumentErrorDomain;

@class SMXMLDocument, SMXMLElementChildren, SMXMLElementValueFinder;

//
// XMLElement class; the workhorse.
//

@interface SMXMLElement : NSObject<NSXMLParserDelegate>

@property (nonatomic, weak) SMXMLDocument *document;
@property (nonatomic, weak) SMXMLElement *parent;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSArray *children;
@property (nonatomic, retain) NSDictionary *attributes;
@property (nonatomic, readonly) SMXMLElement *firstChild, *lastChild;
@property (nonatomic, readonly) SMXMLElementChildren *all;
@property (nonatomic, readonly) SMXMLElementValueFinder *values;

- (id)initWithDocument:(SMXMLDocument *)document;

//
// Method-based document traversing
//

- (SMXMLElement *)childNamed:(NSString *)name;
- (NSArray *)childrenNamed:(NSString *)name;
- (SMXMLElement *)childWithAttribute:(NSString *)attributeName value:(NSString *)attributeValue;
- (NSString *)attributeNamed:(NSString *)name;
- (SMXMLElement *)descendantWithPath:(NSString *)path;
- (NSString *)valueWithPath:(NSString *)path;

- (NSString *)fullDescription; // like -description, this writes the document out to an XML string, but doesn't truncate the node values.
- (NSString *)encodedDescription; // like -fullDescription, but this does HTML encoding of element content

@end

//
// XMLDocument class; simply adds methods to parse an XML document and remember any errors.
//

@interface SMXMLDocument : SMXMLElement

@property (nonatomic, retain) NSError *error;

- (id)initWithData:(NSData *)data error:(NSError **)outError;

+ (SMXMLDocument *)documentWithData:(NSData *)data error:(NSError **)outError;

@end
