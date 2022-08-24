class File {
  String? kind;
  String? id;
  String? name;
  String? mimeType;
  bool? starred;
  bool? trashed;
  bool? explicitlyTrashed;
  List<String>? parents;
  List<String>? spaces;
  String? version;
  String? webContentLink;
  String? webViewLink;
  String? iconLink;
  bool? hasThumbnail;
  String? thumbnailVersion;
  bool? viewedByMe;
  String? createdTime;
  String? modifiedTime;
  String? modifiedByMeTime;
  bool? modifiedByMe;
  List<Owners>? owners;
  Owners? lastModifyingUser;
  bool? shared;
  bool? ownedByMe;
  Capabilities? capabilities;
  bool? viewersCanCopyContent;
  bool? copyRequiresWriterPermission;
  bool? writersCanShare;
  List<Permissions>? permissions;
  List<String>? permissionIds;
  String? originalFilename;
  String? fullFileExtension;
  String? fileExtension;
  String? md5Checksum;
  String? size;
  String? quotaBytesUsed;
  String? headRevisionId;
  bool? isAppAuthorized;
  LinkShareMetadata? linkShareMetadata;

  File(
      {this.kind,
      this.id,
      this.name,
      this.mimeType,
      this.starred,
      this.trashed,
      this.explicitlyTrashed,
      this.parents,
      this.spaces,
      this.version,
      this.webContentLink,
      this.webViewLink,
      this.iconLink,
      this.hasThumbnail,
      this.thumbnailVersion,
      this.viewedByMe,
      this.createdTime,
      this.modifiedTime,
      this.modifiedByMeTime,
      this.modifiedByMe,
      this.owners,
      this.lastModifyingUser,
      this.shared,
      this.ownedByMe,
      this.capabilities,
      this.viewersCanCopyContent,
      this.copyRequiresWriterPermission,
      this.writersCanShare,
      this.permissions,
      this.permissionIds,
      this.originalFilename,
      this.fullFileExtension,
      this.fileExtension,
      this.md5Checksum,
      this.size,
      this.quotaBytesUsed,
      this.headRevisionId,
      this.isAppAuthorized,
      this.linkShareMetadata});

  File.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    id = json['id'];
    name = json['name'];
    mimeType = json['mimeType'];
    starred = json['starred'];
    trashed = json['trashed'];
    explicitlyTrashed = json['explicitlyTrashed'];
    parents = json['parents'].cast<String>();
    spaces = json['spaces'].cast<String>();
    version = json['version'];
    webContentLink = json['webContentLink'];
    webViewLink = json['webViewLink'];
    iconLink = json['iconLink'];
    hasThumbnail = json['hasThumbnail'];
    thumbnailVersion = json['thumbnailVersion'];
    viewedByMe = json['viewedByMe'];
    createdTime = json['createdTime'];
    modifiedTime = json['modifiedTime'];
    modifiedByMeTime = json['modifiedByMeTime'];
    modifiedByMe = json['modifiedByMe'];
    if (json['owners'] != null) {
      owners = <Owners>[];
      json['owners'].forEach((v) {
        owners!.add(new Owners.fromJson(v));
      });
    }
    lastModifyingUser = json['lastModifyingUser'] != null
        ? new Owners.fromJson(json['lastModifyingUser'])
        : null;
    shared = json['shared'];
    ownedByMe = json['ownedByMe'];
    capabilities = json['capabilities'] != null
        ? new Capabilities.fromJson(json['capabilities'])
        : null;
    viewersCanCopyContent = json['viewersCanCopyContent'];
    copyRequiresWriterPermission = json['copyRequiresWriterPermission'];
    writersCanShare = json['writersCanShare'];
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
    permissionIds = json['permissionIds'].cast<String>();
    originalFilename = json['originalFilename'];
    fullFileExtension = json['fullFileExtension'];
    fileExtension = json['fileExtension'];
    md5Checksum = json['md5Checksum'];
    size = json['size'];
    quotaBytesUsed = json['quotaBytesUsed'];
    headRevisionId = json['headRevisionId'];
    isAppAuthorized = json['isAppAuthorized'];
    linkShareMetadata = json['linkShareMetadata'] != null
        ? new LinkShareMetadata.fromJson(json['linkShareMetadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['id'] = this.id;
    data['name'] = this.name;
    data['mimeType'] = this.mimeType;
    data['starred'] = this.starred;
    data['trashed'] = this.trashed;
    data['explicitlyTrashed'] = this.explicitlyTrashed;
    data['parents'] = this.parents;
    data['spaces'] = this.spaces;
    data['version'] = this.version;
    data['webContentLink'] = this.webContentLink;
    data['webViewLink'] = this.webViewLink;
    data['iconLink'] = this.iconLink;
    data['hasThumbnail'] = this.hasThumbnail;
    data['thumbnailVersion'] = this.thumbnailVersion;
    data['viewedByMe'] = this.viewedByMe;
    data['createdTime'] = this.createdTime;
    data['modifiedTime'] = this.modifiedTime;
    data['modifiedByMeTime'] = this.modifiedByMeTime;
    data['modifiedByMe'] = this.modifiedByMe;
    if (this.owners != null) {
      data['owners'] = this.owners!.map((v) => v.toJson()).toList();
    }
    if (this.lastModifyingUser != null) {
      data['lastModifyingUser'] = this.lastModifyingUser!.toJson();
    }
    data['shared'] = this.shared;
    data['ownedByMe'] = this.ownedByMe;
    if (this.capabilities != null) {
      data['capabilities'] = this.capabilities!.toJson();
    }
    data['viewersCanCopyContent'] = this.viewersCanCopyContent;
    data['copyRequiresWriterPermission'] = this.copyRequiresWriterPermission;
    data['writersCanShare'] = this.writersCanShare;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    data['permissionIds'] = this.permissionIds;
    data['originalFilename'] = this.originalFilename;
    data['fullFileExtension'] = this.fullFileExtension;
    data['fileExtension'] = this.fileExtension;
    data['md5Checksum'] = this.md5Checksum;
    data['size'] = this.size;
    data['quotaBytesUsed'] = this.quotaBytesUsed;
    data['headRevisionId'] = this.headRevisionId;
    data['isAppAuthorized'] = this.isAppAuthorized;
    if (this.linkShareMetadata != null) {
      data['linkShareMetadata'] = this.linkShareMetadata!.toJson();
    }
    return data;
  }
}

class Owners {
  String? kind;
  String? displayName;
  String? photoLink;
  bool? me;
  String? permissionId;
  String? emailAddress;

  Owners(
      {this.kind,
      this.displayName,
      this.photoLink,
      this.me,
      this.permissionId,
      this.emailAddress});

  Owners.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    displayName = json['displayName'];
    photoLink = json['photoLink'];
    me = json['me'];
    permissionId = json['permissionId'];
    emailAddress = json['emailAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['displayName'] = this.displayName;
    data['photoLink'] = this.photoLink;
    data['me'] = this.me;
    data['permissionId'] = this.permissionId;
    data['emailAddress'] = this.emailAddress;
    return data;
  }
}

class Capabilities {
  bool? canAcceptOwnership;
  bool? canAddChildren;
  bool? canAddMyDriveParent;
  bool? canChangeCopyRequiresWriterPermission;
  bool? canChangeSecurityUpdateEnabled;
  bool? canChangeViewersCanCopyContent;
  bool? canComment;
  bool? canCopy;
  bool? canDelete;
  bool? canDownload;
  bool? canEdit;
  bool? canListChildren;
  bool? canModifyContent;
  bool? canModifyLabels;
  bool? canMoveChildrenWithinDrive;
  bool? canMoveItemIntoTeamDrive;
  bool? canMoveItemOutOfDrive;
  bool? canMoveItemWithinDrive;
  bool? canReadLabels;
  bool? canReadRevisions;
  bool? canRemoveChildren;
  bool? canRemoveMyDriveParent;
  bool? canRename;
  bool? canShare;
  bool? canTrash;
  bool? canUntrash;

  Capabilities(
      {this.canAcceptOwnership,
      this.canAddChildren,
      this.canAddMyDriveParent,
      this.canChangeCopyRequiresWriterPermission,
      this.canChangeSecurityUpdateEnabled,
      this.canChangeViewersCanCopyContent,
      this.canComment,
      this.canCopy,
      this.canDelete,
      this.canDownload,
      this.canEdit,
      this.canListChildren,
      this.canModifyContent,
      this.canModifyLabels,
      this.canMoveChildrenWithinDrive,
      this.canMoveItemIntoTeamDrive,
      this.canMoveItemOutOfDrive,
      this.canMoveItemWithinDrive,
      this.canReadLabels,
      this.canReadRevisions,
      this.canRemoveChildren,
      this.canRemoveMyDriveParent,
      this.canRename,
      this.canShare,
      this.canTrash,
      this.canUntrash});

  Capabilities.fromJson(Map<String, dynamic> json) {
    canAcceptOwnership = json['canAcceptOwnership'];
    canAddChildren = json['canAddChildren'];
    canAddMyDriveParent = json['canAddMyDriveParent'];
    canChangeCopyRequiresWriterPermission =
        json['canChangeCopyRequiresWriterPermission'];
    canChangeSecurityUpdateEnabled = json['canChangeSecurityUpdateEnabled'];
    canChangeViewersCanCopyContent = json['canChangeViewersCanCopyContent'];
    canComment = json['canComment'];
    canCopy = json['canCopy'];
    canDelete = json['canDelete'];
    canDownload = json['canDownload'];
    canEdit = json['canEdit'];
    canListChildren = json['canListChildren'];
    canModifyContent = json['canModifyContent'];
    canModifyLabels = json['canModifyLabels'];
    canMoveChildrenWithinDrive = json['canMoveChildrenWithinDrive'];
    canMoveItemIntoTeamDrive = json['canMoveItemIntoTeamDrive'];
    canMoveItemOutOfDrive = json['canMoveItemOutOfDrive'];
    canMoveItemWithinDrive = json['canMoveItemWithinDrive'];
    canReadLabels = json['canReadLabels'];
    canReadRevisions = json['canReadRevisions'];
    canRemoveChildren = json['canRemoveChildren'];
    canRemoveMyDriveParent = json['canRemoveMyDriveParent'];
    canRename = json['canRename'];
    canShare = json['canShare'];
    canTrash = json['canTrash'];
    canUntrash = json['canUntrash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canAcceptOwnership'] = this.canAcceptOwnership;
    data['canAddChildren'] = this.canAddChildren;
    data['canAddMyDriveParent'] = this.canAddMyDriveParent;
    data['canChangeCopyRequiresWriterPermission'] =
        this.canChangeCopyRequiresWriterPermission;
    data['canChangeSecurityUpdateEnabled'] =
        this.canChangeSecurityUpdateEnabled;
    data['canChangeViewersCanCopyContent'] =
        this.canChangeViewersCanCopyContent;
    data['canComment'] = this.canComment;
    data['canCopy'] = this.canCopy;
    data['canDelete'] = this.canDelete;
    data['canDownload'] = this.canDownload;
    data['canEdit'] = this.canEdit;
    data['canListChildren'] = this.canListChildren;
    data['canModifyContent'] = this.canModifyContent;
    data['canModifyLabels'] = this.canModifyLabels;
    data['canMoveChildrenWithinDrive'] = this.canMoveChildrenWithinDrive;
    data['canMoveItemIntoTeamDrive'] = this.canMoveItemIntoTeamDrive;
    data['canMoveItemOutOfDrive'] = this.canMoveItemOutOfDrive;
    data['canMoveItemWithinDrive'] = this.canMoveItemWithinDrive;
    data['canReadLabels'] = this.canReadLabels;
    data['canReadRevisions'] = this.canReadRevisions;
    data['canRemoveChildren'] = this.canRemoveChildren;
    data['canRemoveMyDriveParent'] = this.canRemoveMyDriveParent;
    data['canRename'] = this.canRename;
    data['canShare'] = this.canShare;
    data['canTrash'] = this.canTrash;
    data['canUntrash'] = this.canUntrash;
    return data;
  }
}

class Permissions {
  String? kind;
  String? id;
  String? type;
  String? emailAddress;
  String? role;
  String? displayName;
  String? photoLink;
  bool? deleted;
  bool? pendingOwner;

  Permissions(
      {this.kind,
      this.id,
      this.type,
      this.emailAddress,
      this.role,
      this.displayName,
      this.photoLink,
      this.deleted,
      this.pendingOwner});

  Permissions.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    id = json['id'];
    type = json['type'];
    emailAddress = json['emailAddress'];
    role = json['role'];
    displayName = json['displayName'];
    photoLink = json['photoLink'];
    deleted = json['deleted'];
    pendingOwner = json['pendingOwner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['id'] = this.id;
    data['type'] = this.type;
    data['emailAddress'] = this.emailAddress;
    data['role'] = this.role;
    data['displayName'] = this.displayName;
    data['photoLink'] = this.photoLink;
    data['deleted'] = this.deleted;
    data['pendingOwner'] = this.pendingOwner;
    return data;
  }
}

class LinkShareMetadata {
  bool? securityUpdateEligible;
  bool? securityUpdateEnabled;

  LinkShareMetadata({this.securityUpdateEligible, this.securityUpdateEnabled});

  LinkShareMetadata.fromJson(Map<String, dynamic> json) {
    securityUpdateEligible = json['securityUpdateEligible'];
    securityUpdateEnabled = json['securityUpdateEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['securityUpdateEligible'] = this.securityUpdateEligible;
    data['securityUpdateEnabled'] = this.securityUpdateEnabled;
    return data;
  }
}
