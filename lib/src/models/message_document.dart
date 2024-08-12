// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageDocument {
  String documentUrl;
  String documentExtension;
  String previewDocumentUrl;
  String previewDocumentExtension;
  MessageDocument({
    required this.documentUrl,
    required this.documentExtension,
    required this.previewDocumentUrl,
    required this.previewDocumentExtension,
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
      previewDocumentUrl: map['previewDocumentUrl'] as String,
      previewDocumentExtension: map['previewDocumentExtension'] as String,
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
