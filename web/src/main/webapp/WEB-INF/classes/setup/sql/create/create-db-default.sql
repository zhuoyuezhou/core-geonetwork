-- ======================================================================
-- ===   Sql Script for Database : Geonet
-- ===
-- === Build : 153
-- ======================================================================

CREATE TABLE Relations
  (
    id         int not null,
    relatedId  int not null,

    primary key(id,relatedId)
  );

-- ======================================================================

CREATE TABLE Categories
  (
    id    int            not null,
    name  varchar(255)   not null,

    primary key(id),
    unique(name)
  );

-- ======================================================================

CREATE TABLE CustomElementSet
  (
    xpath  varchar(1000)  not null
  );

-- ======================================================================

CREATE TABLE Settings
  (
    id        int            not null,
    parentId  int,
    name      varchar(64)    not null,
    value     longvarchar,

    primary key(id),

    foreign key(parentId) references Settings(id)
  );

-- ======================================================================

CREATE TABLE Languages
  (
    id        varchar(5)   not null,
    name      varchar(32)  not null,
    isocode varchar(3)  not null,
    isInspire char(1)      default 'n',
    isDefault char(1)      default 'n',

    primary key(id)
  );

-- ======================================================================

CREATE TABLE Sources
  (
    uuid     varchar(250)   not null,
    name     varchar(250),
    isLocal  char(1)        default 'y',

    primary key(uuid)
  );

-- ======================================================================

CREATE TABLE IsoLanguages
  (
    id        int          not null,
    code      varchar(3)   not null,
    shortcode varchar(2),

    primary key(id),
    unique(code)
  );

-- ======================================================================

CREATE TABLE IsoLanguagesDes
  (
    idDes   int           not null,
    langId  varchar(5)    not null,
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references IsoLanguages(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Regions
  (
    id     int     not null,
    north  float   not null,
    south  float   not null,
    west   float   not null,
    east   float   not null,

    primary key(id)
  );

-- ======================================================================

CREATE TABLE RegionsDes
  (
    idDes   int           not null,
    langId  varchar(5)    not null,
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Regions(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Users
  (
    id            int           not null,
    username      varchar(256)  not null,
    password      varchar(120)  not null,
    surname       varchar(32),
    name          varchar(32),
    profile       varchar(32)   not null,
    address       varchar(128),
    city          varchar(128),
    state         varchar(32),
    zip           varchar(16),
    country       varchar(128),
    email         varchar(128),
    organisation  varchar(128),
    kind          varchar(16),
    security      varchar(128)  default '',
    authtype      varchar(32),

    primary key(id),
    unique(username)
  );

-- ======================================================================

CREATE TABLE Operations
  (
    id        int           not null,
    name      varchar(32)   not null,
    reserved  char(1)       default 'n' not null,

    primary key(id)
  );

-- ======================================================================

CREATE TABLE OperationsDes
  (
    idDes   int           not null,
    langId  varchar(5)    not null,
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Operations(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Requests
  (
    id             int             not null,
    requestDate    varchar(30),
    ip             varchar(128),
    query          varchar(4000),
    hits           int,
    lang           varchar(16),
    sortBy         varchar(128),
    spatialFilter  varchar(4000),
    type           varchar(4000),
    simple         int             default 1,
    autogenerated  int             default 0,
    service        varchar(128),

    primary key(id)
  );

CREATE INDEX RequestsNDX1 ON Requests(requestDate);
CREATE INDEX RequestsNDX2 ON Requests(ip);
CREATE INDEX RequestsNDX3 ON Requests(hits);
CREATE INDEX RequestsNDX4 ON Requests(lang);

-- ======================================================================

CREATE TABLE Params
  (
    id          int           not null,
    requestId   int,
    queryType   varchar(128),
    termField   varchar(128),
    termText    varchar(128),
    similarity  float,
    lowerText   varchar(128),
    upperText   varchar(128),
    inclusive   char(1),

    primary key(id),

    foreign key(requestId) references Requests(id)
  );

CREATE INDEX ParamsNDX1 ON Params(requestId);
CREATE INDEX ParamsNDX2 ON Params(queryType);
CREATE INDEX ParamsNDX3 ON Params(termField);
CREATE INDEX ParamsNDX4 ON Params(termText);

-- ======================================================================

CREATE TABLE HarvestHistory
  (
    id             int           not null,
    harvestDate    varchar(30),
    elapsedTime    int,
    harvesterUuid  varchar(250),
    harvesterName  varchar(128),
    harvesterType  varchar(128),
    deleted        char(1)       default 'n' not null,
    info           longvarchar,
    params         longvarchar,

    primary key(id)

  );

CREATE INDEX HarvestHistoryNDX1 ON HarvestHistory(harvestDate);

-- ======================================================================

CREATE TABLE Groups
  (
    id           int            not null,
    name         varchar(32)    not null,
    description  varchar(255),
    email        varchar(32),
    referrer     int,

    primary key(id),
    unique(name),

    foreign key(referrer) references Users(id)
  );

-- ======================================================================

CREATE TABLE GroupsDes
  (
    idDes   int           not null,
    langId  varchar(5)    not null,
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Groups(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE UserGroups
  (
    userId   int          not null,
    groupId  int          not null,
    profile  varchar(32)  not null,

    primary key(userId,groupId,profile),

    foreign key(userId) references Users(id),
    foreign key(groupId) references Groups(id)
  );

-- ======================================================================

CREATE TABLE CategoriesDes
  (
    idDes   int            not null,
    langId  varchar(5)     not null,
    label   varchar(255)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Categories(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Metadata
  (
    id           int            not null,
    uuid         varchar(250)   not null,
    schemaId     varchar(32)    not null,
    isTemplate   char(1)        default 'n' not null,
    isHarvested  char(1)        default 'n' not null,
    createDate   varchar(30)    not null,
    changeDate   varchar(30)    not null,
    data         longvarchar    not null,
    source       varchar(250)   not null,
    title        varchar(255),
    root         varchar(255),
    harvestUuid  varchar(250)   default null,
    owner        int            not null,
    doctype      varchar(255),
    groupOwner   int            default null,
    harvestUri   varchar(512)   default null,
    rating       int            default 0 not null,
    popularity   int            default 0 not null,
    displayorder int,

    primary key(id),
    unique(uuid),

    foreign key(owner) references Users(id),
    foreign key(groupOwner) references Groups(id)
  );

CREATE INDEX MetadataNDX1 ON Metadata(uuid);
CREATE INDEX MetadataNDX2 ON Metadata(source);
CREATE INDEX MetadataNDX3 ON Metadata(owner);

-- ======================================================================

CREATE TABLE Validation
  (
    metadataId   int          not null,
    valType      varchar(40)  not null,
    status       int,
    tested       int,
    failed       int,
    valDate      varchar(30),
    
    primary key(metadataId, valType),
    foreign key(metadataId) references Metadata(id)
);

-- ======================================================================

CREATE TABLE MetadataCateg
  (
    metadataId  int not null,
    categoryId  int not null,

    primary key(metadataId,categoryId),

    foreign key(metadataId) references Metadata(id),
    foreign key(categoryId) references Categories(id)
  );

-- ======================================================================

CREATE TABLE StatusValues
  (
    id        int           not null,
    name      varchar(32)   not null,
    reserved  char(1)       default 'n' not null,
    primary key(id)
  );

-- ======================================================================

CREATE TABLE StatusValuesDes
  (
    idDes   int           not null,
    langId  varchar(5)    not null,
    label   varchar(96)   not null,
    primary key(idDes,langId)
  );

-- ======================================================================

CREATE TABLE MetadataStatus
  (
    metadataId      int            not null,
    statusId        int            default 0 not null,
    userId          int            not null,
    changeDate      varchar(30)    not null,
    changeMessage   varchar(2048)  not null,
    primary key(metadataId,statusId,userId,changeDate),
    foreign key(metadataId) references Metadata(id),
    foreign key(statusId)   references StatusValues(id),
    foreign key(userId)     references Users(id)
  );

-- ======================================================================

CREATE TABLE OperationAllowed
  (
    groupId      int not null,
    metadataId   int not null,
    operationId  int not null,

    primary key(groupId,metadataId,operationId),

    foreign key(groupId) references Groups(id),
    foreign key(metadataId) references Metadata(id),
    foreign key(operationId) references Operations(id)
  );

CREATE INDEX OperationAllowedNDX1 ON OperationAllowed(metadataId);

-- ======================================================================

CREATE TABLE MetadataRating
  (
    metadataId  int           not null,
    ipAddress   varchar(32)   not null,
    rating      int           not null,

    primary key(metadataId,ipAddress),

    foreign key(metadataId) references Metadata(id)
  );

-- ======================================================================

CREATE TABLE MetadataNotifiers
  (
    id         int            not null,
    name       varchar(32)    not null,
    url        varchar(255)   not null,
    enabled    char(1)        default 'n' not null,
    username   varchar(32),
    password   varchar(32),

    primary key(id)
  );

-- ======================================================================

CREATE TABLE MetadataNotifications
  (
    metadataId         int            not null,
    notifierId         int            not null,
    notified           char(1)        default 'n' not null,
    metadataUuid       varchar(250)   not null,
    action             char(1)        not null,
    errormsg           text,

    primary key(metadataId,notifierId),

    foreign key(notifierId) references MetadataNotifiers(id)
  );

-- ======================================================================

CREATE TABLE CswServerCapabilitiesInfo
  (
    idField   int           not null,
    langId    varchar(5)    not null,
    field     varchar(32)   not null,
    label     text,

    primary key(idField),

    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Thesaurus
  (
    id           varchar(250)  not null,
    activated    varchar(1),
    primary key(id)
  );

CREATE TABLE schematrondes
 (
  id			int					not null,
  description	varchar(250)		not null,
  
  primary key(id)
 );
CREATE TABLE schematron
 (
  id			int					not null,
  isoschema		varchar(250)		not null,
  file			varchar(250)		not null,
  required		boolean				default 'false' not null,
  description	int					,
  
  primary key(id),
  foreign key(description) references schematrondes(id)
 );