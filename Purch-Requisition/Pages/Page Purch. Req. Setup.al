#pragma implicitwith disable
page 50153 "Purch. Req. Setup_IXO"
{
    PageType = Card;
    Caption = 'Purchase Requisition Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Purch. Req. Setup_IXO";

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Issue Material Batch_IXO"; Rec."Issue Material Batch_IXO")
                {
                    ApplicationArea = All;
                    Caption = 'Issue Material Batch';
                }
                field("Post While Issue Material_IXO"; Rec."Post While Issue Material_IXO")
                {
                    ApplicationArea = All;
                    Caption = 'Post While Issue Material';
                }
                field("Location Validation_IXO"; Rec."Location Validation_IXO")
                {
                    ApplicationArea = All;
                    Caption = 'Location Validation';
                }
                field("Email Notification Required_IXO"; Rec."Email Notification Required")
                {
                    ApplicationArea = All;
                    Caption = 'Email Notification Required';
                }
            }
            group("No Series.")
            {
                field("Purchase Requisition Nos._IXO"; Rec."Purchase Requisition Nos._IXO")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Requisition Nos.';

                }
                field("Material Requisition Nos._IXO"; Rec."Material Requisition Nos._IXO")
                {
                    ApplicationArea = All;
                    Caption = 'Material Requisition Nos.';

                }
            }
            group("G/L Account")
            {
                field("Material Req. G/L Account Cr."; Rec."Material Req. G/L Account Cr.")
                {
                    ApplicationArea = All;
                }
                field("Material Req. G/L Account Dr."; Rec."Material Req. G/L Account Dr.")
                {
                    ApplicationArea = All;
                }
                field("Material Request Gen. Template"; Rec."Material Request Gen. Template")
                {
                    ApplicationArea = All;
                }
                field("Material Request Batch"; Rec."Material Request Batch")
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

        }
    }

    var


    trigger OnOpenPage()
    var

    begin
        Rec.Reset();
        IF NOT Rec.GET() then begin
            Rec.Init();
            Rec.Insert();
        END;
    end;

}
#pragma implicitwith restore
