page 50111 "GL Bank Mismatch Result"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "GL Bank Match Buffer";
    SourceTableTemporary = true;
    Caption = 'GL vs Bank Mismatch Results';
    Editable = false;

    layout
    {
        area(content)
        {
            group(Summary)
            {
                Caption = 'Summary';

                field(GLAccountNoField; GLAccountNoGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account No.';
                    Editable = false;
                }
                field(BankAccountNoField; BankAccountNoGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Ledger No.';
                    Editable = false;
                }
                field(GLEntryCountField; GLEntryCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Entry Count';
                    Editable = false;
                }
                field(GLDocNoCountField; GLDocNoCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Distinct Document No. Count';
                    Editable = false;
                }
                field(BankEntryCountField; BankEntryCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Ledger Entry Count';
                    Editable = false;
                }
                field(BankDocNoCountField; BankDocNoCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Distinct Document No. Count';
                    Editable = false;
                }
                field(MatchedCountField; MatchedCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'Matched';
                    Editable = false;
                }
                field(MismatchedCountField; MismatchedCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'Mismatched';
                    Editable = false;
                }
                field(MissingInBankCountField; MissingInBankCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'Missing in Bank';
                    Editable = false;
                }
                field(MissingInGLCountField; MissingInGLCountGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'Missing in GL';
                    Editable = false;
                }
            }
            repeater(Group)
            {
                field("GL Document No."; Rec."GL Document No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("GL Amount"; Rec."GL Amount")
                {
                    ApplicationArea = All;
                }
                field("Bank Amount"; Rec."Bank Amount")
                {
                    ApplicationArea = All;
                }
                field(Difference; Rec.Difference)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleExpr;
                }
                field("Match Method"; Rec."Match Method")
                {
                    ApplicationArea = All;
                    Caption = 'Matched By';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Matched:
                StatusStyleExpr := 'Favorable';
            Rec.Status::Mismatched, Rec.Status::"Missing in Bank", Rec.Status::"Missing in GL":
                StatusStyleExpr := 'Unfavorable';
            else
                StatusStyleExpr := 'Ambiguous';
        end;
    end;

    trigger OnOpenPage()
    begin
        CalculateStatusCounts();
    end;

    var
        StatusStyleExpr: Text;
        GLAccountNoGlobal: Code[20];
        BankAccountNoGlobal: Code[20];
        GLEntryCountGlobal: Integer;
        BankEntryCountGlobal: Integer;
        GLDocNoCountGlobal: Integer;
        BankDocNoCountGlobal: Integer;
        MatchedCountGlobal: Integer;
        MismatchedCountGlobal: Integer;
        MissingInBankCountGlobal: Integer;
        MissingInGLCountGlobal: Integer;

    // Called by the report to load its temporary result buffer + counts
    procedure SetRecords(var TempBuffer: Record "GL Bank Match Buffer" temporary; GLAccountNo: Code[20]; BankAccountNo: Code[20]; GLEntryCount: Integer; BankEntryCount: Integer; GLDocNoCount: Integer; BankDocNoCount: Integer)
    begin
        GLAccountNoGlobal := GLAccountNo;
        BankAccountNoGlobal := BankAccountNo;
        GLEntryCountGlobal := GLEntryCount;
        BankEntryCountGlobal := BankEntryCount;
        GLDocNoCountGlobal := GLDocNoCount;
        BankDocNoCountGlobal := BankDocNoCount;

        if TempBuffer.FindSet() then
            repeat
                Rec := TempBuffer;
                Rec.Insert();
            until TempBuffer.Next() = 0;
    end;

    local procedure CalculateStatusCounts()
    begin
        Rec.Reset();
        Rec.SetRange(Status, Rec.Status::Matched);
        MatchedCountGlobal := Rec.Count();

        Rec.SetRange(Status, Rec.Status::Mismatched);
        MismatchedCountGlobal := Rec.Count();

        Rec.SetRange(Status, Rec.Status::"Missing in Bank");
        MissingInBankCountGlobal := Rec.Count();

        Rec.SetRange(Status, Rec.Status::"Missing in GL");
        MissingInGLCountGlobal := Rec.Count();

        Rec.Reset();
    end;
}