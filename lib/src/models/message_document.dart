// This file is part of the mongo_chat_dart package.
// 
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageDocument {
  String documentUrl;
  String documentExtension;
  String? previewDocumentUrl;
  String? previewDocumentExtension;
  MessageDocument({
    required this.documentUrl,
    required this.documentExtension,
    this.previewDocumentUrl,
    this.previewDocumentExtension,
  });

  MessageDocument copyWith({
    String? documentUrl,
    String? documentExtension,
    String? previewDocumentUrl,
    String? previewDocumentExtension,
  }) {
    return MessageDocument(
      documentUrl: documentUrl ?? this.documentUrl,
      documentExtension: documentExtension ?? this.documentExtension,
      previewDocumentUrl: previewDocumentUrl ?? this.previewDocumentUrl,
      previewDocumentExtension:
          previewDocumentExtension ?? this.previewDocumentExtension,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentUrl': documentUrl,
      'documentExtension': documentExtension,
      'previewDocumentUrl': previewDocumentUrl,
      'previewDocumentExtension': previewDocumentExtension,
    };
  }

  factory MessageDocument.fromMap(Map<String, dynamic> map) {
    return MessageDocument(
      documentUrl: map['documentUrl'] as String,
      documentExtension: map['documentExtension'] as String,
      previewDocumentUrl: map['previewDocumentUrl'] != null
          ? map['previewDocumentUrl'] as String
          : null,
      previewDocumentExtension: map['previewDocumentExtension'] != null
          ? map['previewDocumentExtension'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageDocument.fromJson(String source) =>
      MessageDocument.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageDocument(documentUrl: $documentUrl, documentExtension: $documentExtension, previewDocumentUrl: $previewDocumentUrl, previewDocumentExtension: $previewDocumentExtension)';
  }

  @override
  bool operator ==(covariant MessageDocument other) {
    if (identical(this, other)) return true;

    return other.documentUrl == documentUrl &&
        other.documentExtension == documentExtension &&
        other.previewDocumentUrl == previewDocumentUrl &&
        other.previewDocumentExtension == previewDocumentExtension;
  }

  @override
  int get hashCode {
    return documentUrl.hashCode ^
        documentExtension.hashCode ^
        previewDocumentUrl.hashCode ^
        previewDocumentExtension.hashCode;
  }
}
