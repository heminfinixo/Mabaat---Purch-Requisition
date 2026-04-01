codeunit 50150 "FileUploadDownload_IXO"
{
    trigger OnRun()
    begin

    end;


    procedure UploadAttachment(LineNo: Integer; ItemNo: Code[20]; DocNo: Code[20])
    var
        AttachmentRec: Record "Attachment Copy_IXO";
        FileOutStream: OutStream;
        FileInStream: InStream;
        tempfilename: text;
        DialogTitleLbl: Label 'Please select a File...';
    begin
        if not AttachmentRec.Get(DocNo, LineNo) then begin
            if UploadIntoStream(DialogTitleLbl, '', 'All Files (*.*)|*.*', tempfilename, FileInStream) then begin
                AttachmentRec.Init();
                AttachmentRec."Storage Type_IXO" := AttachmentRec."Storage Type_IXO"::Embedded;
                // Evaluate(AttachmentRec."Storage Pointer_IXO", tempfilename);
                AttachmentRec."Storage Pointer_IXO" := Format(tempfilename);
                // Evaluate(AttachmentRec."File Extension_IXO", GetFileType(tempfilename));
                AttachmentRec."File Extension_IXO" := format(GetFileType(tempfilename));
                AttachmentRec."Attachment File_IXO".CreateOutStream(FileOutStream);
                AttachmentRec."Item No._IXO" := ItemNo;
                AttachmentRec."Line No_IXO" := LineNo;
                AttachmentRec."Doc No._IXO" := DocNo;
                CopyStream(FileOutStream, FileInStream);
                AttachmentRec.Insert();
                //AttachmentRec.Modify(true);
                // Message('File Successfully Uploaded.');
                Message('File %1 has been Successfully Uploaded', AttachmentRec."Storage Pointer_IXO");

            end
        end
        else
            if AttachmentRec.Get(DocNo, LineNo) then
                IF Confirm('File Already Attached do you want to Overwrite?', true) then
                    if UploadIntoStream(DialogTitleLbl, '', 'All Files (*.*)|*.*', tempfilename, FileInStream) then begin
                        AttachmentRec.Init();
                        AttachmentRec."Storage Type_IXO" := AttachmentRec."Storage Type_IXO"::Embedded;
                        AttachmentRec."Storage Pointer_IXO" := format(tempfilename);
                        AttachmentRec."File Extension_IXO" := format(GetFileType(tempfilename));
                        AttachmentRec."Attachment File_IXO".CreateOutStream(FileOutStream);
                        AttachmentRec."Item No._IXO" := ItemNo;
                        AttachmentRec."Line No_IXO" := LineNo;
                        AttachmentRec."Doc No._IXO" := DocNo;
                        CopyStream(FileOutStream, FileInStream);
                        AttachmentRec.Modify(true);
                        Message('File %1 has been Successfully Uploaded', AttachmentRec."Storage Pointer_IXO");

                    end;

    end;

    local procedure GetFileType(pFilename: Text): Text;
    var
        FilenamePos: Integer;
    begin
        FilenamePos := StrLen(pFilename);
        while (pFilename[FilenamePos] <> '.') or (FilenamePos < 1) do
            FilenamePos -= 1;

        if FilenamePos = 0 then
            exit('');

        exit(CopyStr(pFilename, FilenamePos + 1, StrLen(pFilename)));
    end;

    procedure OpenAttachment(LineNo: Integer; DocNo: Code[20])
    var
        AttachmentRec: record "Attachment Copy_IXO";
        ResponseStream: InStream;
        tempfilename: text;
        ErrorAttachmentLbl: Label 'No file available.';
    begin
        if AttachmentRec.get(DocNo, LineNo) then
            if AttachmentRec."Attachment File_IXO".HasValue() then begin
                AttachmentRec.CalcFields("Attachment File_IXO");
                AttachmentRec."Attachment File_IXO".CreateInStream(ResponseStream);
                tempfilename := AttachmentRec."Storage Pointer_IXO";
                // tempfilename := AttachmentRec."Storage Pointer_IXO" + '.' + AttachmentRec."File Extension_IXO";
                DOWNLOADFROMSTREAM(ResponseStream, 'Export', '', 'All Files (*.*)|*.*', tempfilename);
            end
            else
                Error(ErrorAttachmentLbl);
    end;

    procedure DeleteAttachment(LineNo: Integer; DocNo: Code[20])
    var
        AttachmentRec: record "Attachment Copy_IXO";

        ErrorAttachmentLbl: Label 'No file available.';
    begin
        if AttachmentRec.get(DocNo, LineNo) then
            if AttachmentRec."Attachment File_IXO".HasValue() then begin
                AttachmentRec.Delete(true);
                Message('File %1 has been Succesfully Deleted.', AttachmentRec."Storage Pointer_IXO");
            end
            else
                Error(ErrorAttachmentLbl);
    end;

    var

}