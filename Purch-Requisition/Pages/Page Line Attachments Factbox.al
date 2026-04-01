#pragma implicitwith disable
page 50162 "Line Attachment Factbox_IXO"
{
    PageType = CardPart;
    // ApplicationArea = All;
    Caption = 'Line File Attachments';
    //  UsageCategory = Administration;
    SourceTable = "Attachment Copy_IXO";

    layout
    {
        area(Content)
        {
            group(" ")
            {
                /*    field("Attachment File_IXO"; "Attachment File_IXO")
                   {
                       ApplicationArea = All;

                   } */
                field("File Name"; Rec."Storage Pointer_IXO")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified_IXO"; Rec."Last Date Modified_IXO")
                {
                    ApplicationArea = All;

                }
                field("Last Time Modified_IXO"; Rec."Last Time Modified_IXO")
                {
                    ApplicationArea = All;
                }
                field("File Extension_IXO"; Rec."File Extension_IXO")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Delete Attachment")
            {
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Delete the File Uploaded Permanently';

                trigger OnAction()
                begin
                    IF Dialog.Confirm('Are you sure you want to delete the attachment', true) then
                        FileUpload.DeleteAttachment(Rec."Line No_IXO", Rec."Doc No._IXO");
                end;
            }
        }
    }

    var
        FileUpload: Codeunit "FileUploadDownload_IXO";

}
#pragma implicitwith restore
