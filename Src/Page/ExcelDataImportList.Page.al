page 50111 "Excel Data Import List"
{

    ApplicationArea = All;
    Caption = 'Excel Data Import List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Excel Data Import";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number';
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the exchange rate';
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the LCY value';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportExcel)
            {
                ApplicationArea = All;
                Caption = 'Import from Excel';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Import exchange rate data from Excel file';

                trigger OnAction()
                var
                    ImportMgt: Codeunit "Excel Import Management";
                begin
                    ImportMgt.ImportFromExcel();
                end;
            }
            action(DeleteAll)
            {
                ApplicationArea = All;
                Caption = 'Delete All';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Delete all imported records';

                trigger OnAction()
                begin
                    if Confirm('Delete all records?', false) then
                        Rec.DeleteAll();
                end;
            }
        }
    }
}