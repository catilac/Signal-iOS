//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDBCipher
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - SDSSerializable

extension TSAttachment: SDSSerializable {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        case let model as TSAttachmentStream:
            assert(type(of: model) == TSAttachmentStream.self)
            return TSAttachmentStreamSerializer(model: model)
        case let model as TSAttachmentPointer:
            assert(type(of: model) == TSAttachmentPointer.self)
            return TSAttachmentPointerSerializer(model: model)
        default:
            return TSAttachmentSerializer(model: self)
        }
    }
}

// MARK: - Table Metadata

extension TSAttachmentSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static let recordTypeColumn = SDSColumnMetadata(columnName: "recordType", columnType: .int, columnIndex: 0)
    static let uniqueIdColumn = SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, columnIndex: 1)
    // Base class properties
    static let albumMessageIdColumn = SDSColumnMetadata(columnName: "albumMessageId", columnType: .unicodeString, isOptional: true, columnIndex: 2)
    static let attachmentSchemaVersionColumn = SDSColumnMetadata(columnName: "attachmentSchemaVersion", columnType: .int64, columnIndex: 3)
    static let attachmentTypeColumn = SDSColumnMetadata(columnName: "attachmentType", columnType: .int, columnIndex: 4)
    static let byteCountColumn = SDSColumnMetadata(columnName: "byteCount", columnType: .int, columnIndex: 5)
    static let captionColumn = SDSColumnMetadata(columnName: "caption", columnType: .unicodeString, isOptional: true, columnIndex: 6)
    static let contentTypeColumn = SDSColumnMetadata(columnName: "contentType", columnType: .unicodeString, columnIndex: 7)
    static let encryptionKeyColumn = SDSColumnMetadata(columnName: "encryptionKey", columnType: .blob, isOptional: true, columnIndex: 8)
    static let isDownloadedColumn = SDSColumnMetadata(columnName: "isDownloaded", columnType: .int, columnIndex: 9)
    static let serverIdColumn = SDSColumnMetadata(columnName: "serverId", columnType: .int64, columnIndex: 10)
    static let sourceFilenameColumn = SDSColumnMetadata(columnName: "sourceFilename", columnType: .unicodeString, isOptional: true, columnIndex: 11)
    // Subclass properties
    static let cachedAudioDurationSecondsColumn = SDSColumnMetadata(columnName: "cachedAudioDurationSeconds", columnType: .double, isOptional: true, columnIndex: 12)
    static let cachedImageHeightColumn = SDSColumnMetadata(columnName: "cachedImageHeight", columnType: .double, isOptional: true, columnIndex: 13)
    static let cachedImageWidthColumn = SDSColumnMetadata(columnName: "cachedImageWidth", columnType: .double, isOptional: true, columnIndex: 14)
    static let creationTimestampColumn = SDSColumnMetadata(columnName: "creationTimestamp", columnType: .int64, isOptional: true, columnIndex: 15)
    static let digestColumn = SDSColumnMetadata(columnName: "digest", columnType: .blob, isOptional: true, columnIndex: 16)
    static let isUploadedColumn = SDSColumnMetadata(columnName: "isUploaded", columnType: .int, isOptional: true, columnIndex: 17)
    static let isValidImageCachedColumn = SDSColumnMetadata(columnName: "isValidImageCached", columnType: .int, isOptional: true, columnIndex: 18)
    static let isValidVideoCachedColumn = SDSColumnMetadata(columnName: "isValidVideoCached", columnType: .int, isOptional: true, columnIndex: 19)
    static let lazyRestoreFragmentIdColumn = SDSColumnMetadata(columnName: "lazyRestoreFragmentId", columnType: .unicodeString, isOptional: true, columnIndex: 20)
    static let localRelativeFilePathColumn = SDSColumnMetadata(columnName: "localRelativeFilePath", columnType: .unicodeString, isOptional: true, columnIndex: 21)
    static let mediaSizeColumn = SDSColumnMetadata(columnName: "mediaSize", columnType: .blob, isOptional: true, columnIndex: 22)
    static let mostRecentFailureLocalizedTextColumn = SDSColumnMetadata(columnName: "mostRecentFailureLocalizedText", columnType: .unicodeString, isOptional: true, columnIndex: 23)
    static let pointerTypeColumn = SDSColumnMetadata(columnName: "pointerType", columnType: .int, isOptional: true, columnIndex: 24)
    static let stateColumn = SDSColumnMetadata(columnName: "state", columnType: .int, isOptional: true, columnIndex: 25)

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static let table = SDSTableMetadata(tableName: "model_TSAttachment", columns: [
        recordTypeColumn,
        uniqueIdColumn,
        albumMessageIdColumn,
        attachmentSchemaVersionColumn,
        attachmentTypeColumn,
        byteCountColumn,
        captionColumn,
        contentTypeColumn,
        encryptionKeyColumn,
        isDownloadedColumn,
        serverIdColumn,
        sourceFilenameColumn,
        cachedAudioDurationSecondsColumn,
        cachedImageHeightColumn,
        cachedImageWidthColumn,
        creationTimestampColumn,
        digestColumn,
        isUploadedColumn,
        isValidImageCachedColumn,
        isValidVideoCachedColumn,
        lazyRestoreFragmentIdColumn,
        localRelativeFilePathColumn,
        mediaSizeColumn,
        mostRecentFailureLocalizedTextColumn,
        pointerTypeColumn,
        stateColumn
        ])

}

// MARK: - Deserialization

extension TSAttachmentSerializer {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func sdsDeserialize(statement: SelectStatement) throws -> TSAttachment {

        if OWSIsDebugBuild() {
            guard statement.columnNames == table.selectColumnNames else {
                owsFailDebug("Unexpected columns: \(statement.columnNames) != \(table.selectColumnNames)")
                throw SDSError.invalidResult
            }
        }

        // SDSDeserializer is used to convert column values into Swift values.
        let deserializer = SDSDeserializer(sqliteStatement: statement.sqliteStatement)
        let recordTypeValue = try deserializer.int(at: 0)
        guard let recordType = SDSRecordType(rawValue: UInt(recordTypeValue)) else {
            owsFailDebug("Invalid recordType: \(recordTypeValue)")
            throw SDSError.invalidResult
        }
        switch recordType {
        case .attachmentPointer:

            let uniqueId = try deserializer.string(at: uniqueIdColumn.columnIndex)
            let albumMessageId = try deserializer.optionalString(at: albumMessageIdColumn.columnIndex)
            let attachmentSchemaVersion = UInt(try deserializer.int64(at: attachmentSchemaVersionColumn.columnIndex))
            let attachmentTypeRaw = UInt(try deserializer.int(at: attachmentTypeColumn.columnIndex))
            guard let attachmentType = TSAttachmentType(rawValue: attachmentTypeRaw) else {
               throw SDSError.invalidValue
            }
            let byteCount = UInt32(try deserializer.int64(at: byteCountColumn.columnIndex))
            let caption = try deserializer.optionalString(at: captionColumn.columnIndex)
            let contentType = try deserializer.string(at: contentTypeColumn.columnIndex)
            let encryptionKey = try deserializer.optionalBlob(at: encryptionKeyColumn.columnIndex)
            let isDownloaded = try deserializer.bool(at: isDownloadedColumn.columnIndex)
            let serverId = try deserializer.uint64(at: serverIdColumn.columnIndex)
            let sourceFilename = try deserializer.optionalString(at: sourceFilenameColumn.columnIndex)
            let digest = try deserializer.optionalBlob(at: digestColumn.columnIndex)
            let lazyRestoreFragmentId = try deserializer.optionalString(at: lazyRestoreFragmentIdColumn.columnIndex)
            let mediaSizeSerialized: Data = try deserializer.blob(at: mediaSizeColumn.columnIndex)
            let mediaSize: CGSize = try SDSDeserializer.unarchive(mediaSizeSerialized)
            let mostRecentFailureLocalizedText = try deserializer.optionalString(at: mostRecentFailureLocalizedTextColumn.columnIndex)
            let pointerTypeRaw = UInt(try deserializer.int(at: pointerTypeColumn.columnIndex))
            guard let pointerType = TSAttachmentPointerType(rawValue: pointerTypeRaw) else {
               throw SDSError.invalidValue
            }
            let stateRaw = UInt(try deserializer.int(at: stateColumn.columnIndex))
            guard let state = TSAttachmentPointerState(rawValue: stateRaw) else {
               throw SDSError.invalidValue
            }

            return TSAttachmentPointer(uniqueId: uniqueId,
                                       albumMessageId: albumMessageId,
                                       attachmentSchemaVersion: attachmentSchemaVersion,
                                       attachmentType: attachmentType,
                                       byteCount: byteCount,
                                       caption: caption,
                                       contentType: contentType,
                                       encryptionKey: encryptionKey,
                                       isDownloaded: isDownloaded,
                                       serverId: serverId,
                                       sourceFilename: sourceFilename,
                                       digest: digest,
                                       lazyRestoreFragmentId: lazyRestoreFragmentId,
                                       mediaSize: mediaSize,
                                       mostRecentFailureLocalizedText: mostRecentFailureLocalizedText,
                                       pointerType: pointerType,
                                       state: state)

        case .attachmentStream:

            let uniqueId = try deserializer.string(at: uniqueIdColumn.columnIndex)
            let albumMessageId = try deserializer.optionalString(at: albumMessageIdColumn.columnIndex)
            let attachmentSchemaVersion = UInt(try deserializer.int64(at: attachmentSchemaVersionColumn.columnIndex))
            let attachmentTypeRaw = UInt(try deserializer.int(at: attachmentTypeColumn.columnIndex))
            guard let attachmentType = TSAttachmentType(rawValue: attachmentTypeRaw) else {
               throw SDSError.invalidValue
            }
            let byteCount = UInt32(try deserializer.int64(at: byteCountColumn.columnIndex))
            let caption = try deserializer.optionalString(at: captionColumn.columnIndex)
            let contentType = try deserializer.string(at: contentTypeColumn.columnIndex)
            let encryptionKey = try deserializer.optionalBlob(at: encryptionKeyColumn.columnIndex)
            let isDownloaded = try deserializer.bool(at: isDownloadedColumn.columnIndex)
            let serverId = try deserializer.uint64(at: serverIdColumn.columnIndex)
            let sourceFilename = try deserializer.optionalString(at: sourceFilenameColumn.columnIndex)
            let cachedAudioDurationSeconds = try deserializer.optionalDoubleAsNSNumber(at: cachedAudioDurationSecondsColumn.columnIndex)
            let cachedImageHeight = try deserializer.optionalDoubleAsNSNumber(at: cachedImageHeightColumn.columnIndex)
            let cachedImageWidth = try deserializer.optionalDoubleAsNSNumber(at: cachedImageWidthColumn.columnIndex)
            let creationTimestamp = try deserializer.date(at: creationTimestampColumn.columnIndex)
            let digest = try deserializer.optionalBlob(at: digestColumn.columnIndex)
            let isUploaded = try deserializer.bool(at: isUploadedColumn.columnIndex)
            let isValidImageCached = try deserializer.optionalBoolAsNSNumber(at: isValidImageCachedColumn.columnIndex)
            let isValidVideoCached = try deserializer.optionalBoolAsNSNumber(at: isValidVideoCachedColumn.columnIndex)
            let localRelativeFilePath = try deserializer.optionalString(at: localRelativeFilePathColumn.columnIndex)

            return TSAttachmentStream(uniqueId: uniqueId,
                                      albumMessageId: albumMessageId,
                                      attachmentSchemaVersion: attachmentSchemaVersion,
                                      attachmentType: attachmentType,
                                      byteCount: byteCount,
                                      caption: caption,
                                      contentType: contentType,
                                      encryptionKey: encryptionKey,
                                      isDownloaded: isDownloaded,
                                      serverId: serverId,
                                      sourceFilename: sourceFilename,
                                      cachedAudioDurationSeconds: cachedAudioDurationSeconds,
                                      cachedImageHeight: cachedImageHeight,
                                      cachedImageWidth: cachedImageWidth,
                                      creationTimestamp: creationTimestamp,
                                      digest: digest,
                                      isUploaded: isUploaded,
                                      isValidImageCached: isValidImageCached,
                                      isValidVideoCached: isValidVideoCached,
                                      localRelativeFilePath: localRelativeFilePath)

        case .attachment:

            let uniqueId = try deserializer.string(at: uniqueIdColumn.columnIndex)
            let albumMessageId = try deserializer.optionalString(at: albumMessageIdColumn.columnIndex)
            let attachmentSchemaVersion = UInt(try deserializer.int64(at: attachmentSchemaVersionColumn.columnIndex))
            let attachmentTypeRaw = UInt(try deserializer.int(at: attachmentTypeColumn.columnIndex))
            guard let attachmentType = TSAttachmentType(rawValue: attachmentTypeRaw) else {
               throw SDSError.invalidValue
            }
            let byteCount = UInt32(try deserializer.int64(at: byteCountColumn.columnIndex))
            let caption = try deserializer.optionalString(at: captionColumn.columnIndex)
            let contentType = try deserializer.string(at: contentTypeColumn.columnIndex)
            let encryptionKey = try deserializer.optionalBlob(at: encryptionKeyColumn.columnIndex)
            let isDownloaded = try deserializer.bool(at: isDownloadedColumn.columnIndex)
            let serverId = try deserializer.uint64(at: serverIdColumn.columnIndex)
            let sourceFilename = try deserializer.optionalString(at: sourceFilenameColumn.columnIndex)

            return TSAttachment(uniqueId: uniqueId,
                                albumMessageId: albumMessageId,
                                attachmentSchemaVersion: attachmentSchemaVersion,
                                attachmentType: attachmentType,
                                byteCount: byteCount,
                                caption: caption,
                                contentType: contentType,
                                encryptionKey: encryptionKey,
                                isDownloaded: isDownloaded,
                                serverId: serverId,
                                sourceFilename: sourceFilename)

        default:
            owsFail("Invalid record type \(recordType)")
        }
    }
}

// MARK: - Save/Remove/Update

@objc
extension TSAttachment {
    @objc
    public func anySave(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            save(with: ydbTransaction)
        case .grdbWrite(let grdbTransaction):
            SDSSerialization.save(entity: self, transaction: grdbTransaction)
        }
    }

    @objc
    public func anyRemove(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            remove(with: ydbTransaction)
        case .grdbWrite(let grdbTransaction):
            SDSSerialization.delete(entity: self, transaction: grdbTransaction)
        }
    }
}

// MARK: - TSAttachmentCursor

@objc
public class TSAttachmentCursor: NSObject {
    private let cursor: SDSCursor<TSAttachment>

    init(cursor: SDSCursor<TSAttachment>) {
        self.cursor = cursor
    }

    // TODO: Revisit error handling in this class.
    public func next() throws -> TSAttachment? {
        return try cursor.next()
    }

    public func all() throws -> [TSAttachment] {
        return try cursor.all()
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
extension TSAttachment {
    public class func grdbFetchCursor(transaction: GRDBReadTransaction) -> TSAttachmentCursor {
        return TSAttachmentCursor(cursor: SDSSerialization.fetchCursor(tableMetadata: TSAttachmentSerializer.table,
                                                                   transaction: transaction,
                                                                   deserialize: TSAttachmentSerializer.sdsDeserialize))
    }

    // Fetches a single model by "unique id".
    @objc
    public class func anyFetch(withUniqueId uniqueId: String,
                               transaction: SDSAnyReadTransaction) -> TSAttachment? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return TSAttachment.fetch(uniqueId: uniqueId, transaction: ydbTransaction)
        case .grdbRead(let grdbTransaction):
            let tableMetadata = TSAttachmentSerializer.table
            let columnNames: [String] = tableMetadata.selectColumnNames
            let columnsSQL: String = columnNames.map { $0.quotedDatabaseIdentifier }.joined(separator: ", ")
            let tableName: String = tableMetadata.tableName
            let uniqueIdColumnName: String = TSAttachmentSerializer.uniqueIdColumn.columnName
            let sql: String = "SELECT \(columnsSQL) FROM \(tableName.quotedDatabaseIdentifier) WHERE \(uniqueIdColumnName.quotedDatabaseIdentifier) == ?"

            let cursor = TSAttachment.grdbFetchCursor(sql: sql,
                                                  arguments: [uniqueId],
                                                  transaction: grdbTransaction)
            do {
                return try cursor.next()
            } catch {
                owsFailDebug("error: \(error)")
                return nil
            }
        }
    }
}

// MARK: - Swift Fetch

extension TSAttachment {
    public class func grdbFetchCursor(sql: String,
                                      arguments: [DatabaseValueConvertible]?,
                                      transaction: GRDBReadTransaction) -> TSAttachmentCursor {
        var statementArguments: StatementArguments?
        if let arguments = arguments {
            guard let statementArgs = StatementArguments(arguments) else {
                owsFail("Could not convert arguments.")
            }
            statementArguments = statementArgs
        }
        return TSAttachmentCursor(cursor: SDSSerialization.fetchCursor(sql: sql,
                                                             arguments: statementArguments,
                                                             transaction: transaction,
                                                                   deserialize: TSAttachmentSerializer.sdsDeserialize))
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class TSAttachmentSerializer: SDSSerializer {

    private let model: TSAttachment
    public required init(model: TSAttachment) {
        self.model = model
    }

    public func serializableColumnTableMetadata() -> SDSTableMetadata {
        return TSAttachmentSerializer.table
    }

    public func insertColumnNames() -> [String] {
        // When we insert a new row, we include the following columns:
        //
        // * "record type"
        // * "unique id"
        // * ...all columns that we set when updating.
        return [
            TSAttachmentSerializer.recordTypeColumn.columnName,
            uniqueIdColumnName()
            ] + updateColumnNames()

    }

    public func insertColumnValues() -> [DatabaseValueConvertible] {
        let result: [DatabaseValueConvertible] = [
            SDSRecordType.attachment.rawValue
            ] + [uniqueIdColumnValue()] + updateColumnValues()
        if OWSIsDebugBuild() {
            if result.count != insertColumnNames().count {
                owsFailDebug("Update mismatch: \(result.count) != \(insertColumnNames().count)")
            }
        }
        return result
    }

    public func updateColumnNames() -> [String] {
        return [
            TSAttachmentSerializer.albumMessageIdColumn,
            TSAttachmentSerializer.attachmentSchemaVersionColumn,
            TSAttachmentSerializer.attachmentTypeColumn,
            TSAttachmentSerializer.byteCountColumn,
            TSAttachmentSerializer.captionColumn,
            TSAttachmentSerializer.contentTypeColumn,
            TSAttachmentSerializer.encryptionKeyColumn,
            TSAttachmentSerializer.isDownloadedColumn,
            TSAttachmentSerializer.serverIdColumn,
            TSAttachmentSerializer.sourceFilenameColumn
            ].map { $0.columnName }
    }

    public func updateColumnValues() -> [DatabaseValueConvertible] {
        let result: [DatabaseValueConvertible] = [
            self.model.albumMessageId ?? DatabaseValue.null,
            self.model.attachmentSchemaVersion,
            self.model.attachmentType.rawValue,
            self.model.byteCount,
            self.model.caption ?? DatabaseValue.null,
            self.model.contentType,
            self.model.encryptionKey ?? DatabaseValue.null,
            self.model.isDownloaded,
            self.model.serverId,
            self.model.sourceFilename ?? DatabaseValue.null

        ]
        if OWSIsDebugBuild() {
            if result.count != updateColumnNames().count {
                owsFailDebug("Update mismatch: \(result.count) != \(updateColumnNames().count)")
            }
        }
        return result
    }

    public func uniqueIdColumnName() -> String {
        return TSAttachmentSerializer.uniqueIdColumn.columnName
    }

    // TODO: uniqueId is currently an optional on our models.
    //       We should probably make the return type here String?
    public func uniqueIdColumnValue() -> DatabaseValueConvertible {
        // FIXME remove force unwrap
        return model.uniqueId!
    }
}
