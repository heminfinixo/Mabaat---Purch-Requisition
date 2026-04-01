// [log#01]: asif - 24SEP19 created report...
report 50150 "Purchase Requisition IXO"
{
    //  UsageCategory = Administration;
    //  ApplicationArea = All;
    Caption = 'Purchase Requisition';
    RDLCLayout = './ReportLayouts/PurchseReq.rdl';

    dataset
    {
        dataitem("Purchase Req. Header_IXO"; "Purchase Req. Header_IXO")
        {
            column(Document_No_; "Document No.")
            {

            }
            column(Document_Date; "Document Date")
            {
                //Request date
            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Subject; Subject)
            {

            }
            column(Created_By_User; "Created By User")
            {

            }
            column(CompanyInfo; CompanyInfo.Picture)
            {

            }
            column(FromRefLbl; FromRefLbl)
            {

            }
            column(ItemDescLbl; ItemDescLbl)
            {
            }
            column(PurchasePurposeLbl; PurchasePurposeLbl)
            {

            }
            column(PurchaseReqHdrLbl; PurchaseReqHdrLbl)
            {

            }
            column(QtyLbl; QtyLbl)
            {

            }
            column(RequestDateLbl; RequestDateLbl)
            {

            }
            column(RequestedByLbl; RequestedByLbl)
            {

            }
            column(RequiredDateLbl; RequiredDateLbl)
            {

            }
            column(SerialNoLbl; SerialNoLbl)
            {

            }
            column(EmpUserName; EmpUserName)
            {

            }
            column(RequestDateText; RequestDateText)
            {

            }
            column(RequiredDateText; RequiredDateText)
            {

            }

            dataitem("Purchase Requisition Line_IXO"; "Purchase Requisition Line_IXO")
            {
                DataItemLinkReference = "Purchase Req. Header_IXO";
                DataItemLink = "Document No." = field("Document No.");
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(PurchasePurpose; PurchasePurpose)
                {

                }
                column(SerialNo; SerialNo)
                {

                }
                trigger OnAfterGetRecord()
                var
                    ReasonCode_lRec: Record "Reason Code";
                begin
                    If "Purchase Requisition Line_IXO".Type = "Purchase Requisition Line_IXO".Type::" " then begin
                        PurchasePurpose := '';
                        LastSerialNo := SerialNo;
                        SerialNo := 0;
                    end else begin
                        if ReasonCode_lRec.get("Reason Code") then
                            PurchasePurpose := ReasonCode_lRec.Description;
                        if LastSerialNo > 0 then begin
                            SerialNo := LastSerialNo + 1;
                            LastSerialNo := 0;
                        end else
                            SerialNo := SerialNo + 1;
                    end;
                end;

            }

            trigger OnPreDataItem()
            var
                Users_lRec: Record User;
            begin
                if DocNo <> '' then
                    "Purchase Req. Header_IXO".SetRange("Purchase Req. Header_IXO"."Document No.", DocNo);
                if "Purchase Req. Header_IXO".FindFirst() then begin
                    RequestDateText := FORMAT("Purchase Req. Header_IXO"."Document Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
                    RequiredDateText := FORMAT("Purchase Req. Header_IXO"."Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
                    Users_lRec.Reset();
                    Users_lRec.SetRange(Users_lRec."User Name", "Purchase Req. Header_IXO"."Created By User");
                    if Users_lRec.FindFirst() then
                        EmpUserName := Users_lRec."Full Name";
                end;
            end;
        }

    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field("Document No."; DocNo)
                    {
                        ApplicationArea = All;
                        TableRelation = "Purchase Req. Header_IXO"."Document No.";

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        Clear(SerialNo);
        Clear(LastSerialNo);
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    procedure SetParameter(DocumentNo: Code[20])
    var
    begin
        DocNo := DocumentNo;
    end;

    var
        CompanyInfo: Record "Company Information";
        DocNo: Code[20];
        SerialNo: Integer;
        LastSerialNo: Integer;
        EmpUserName: Text[80];
        RequestDateText: Text[12];
        RequiredDateText: Text[12];
        PurchasePurpose: Text[100];
        PurchaseReqHdrLbl: Label 'Purchase Request';
        FromRefLbl: Label 'Document No.';
        RequestDateLbl: Label 'Request Date';
        RequiredDateLbl: Label 'Required Date';
        RequestedByLbl: Label 'Requested By';
        SerialNoLbl: Label 'Serial No.';
        ItemDescLbl: Label 'Item Description';
        QtyLbl: Label 'Quantity';
        PurchasePurposeLbl: Label 'Purchase Purpose';
}