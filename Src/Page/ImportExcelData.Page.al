page 50124 "Import Excel Data"
{
    ApplicationArea = All;
    Caption = 'Excel Data Import';
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

                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value additional';
                }

                field("Legend"; Rec."Legend")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legend';
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
                ToolTip = 'Import General data from Excel file';

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