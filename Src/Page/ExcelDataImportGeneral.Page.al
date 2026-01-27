page 50114 "Excel Data Import General"
{

    ApplicationArea = All;
    Caption = 'Excel Data Import General';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Excel Data Import General";

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
                field("Entry##"; Rec."Entry##")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number';
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the LCY value';
                }

                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the text value';
                }
                field(UpdateField; Rec.UpdateField)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the update field';
                }

                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code value';
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
                Caption = 'Import from Excel General';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Import General data from Excel file';

                trigger OnAction()
                var
                    ImportMgt: Codeunit "Excel Import Mngmnt General";
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