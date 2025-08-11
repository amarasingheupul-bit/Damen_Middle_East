tableextension 50113 "4HC Job Task" extends "Job Task"
{
    fields
    {
        field(50100; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ObsoleteState = Removed;
        }
        field(50101; "4HC Schedule (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Job Planning Line"."Total Cost" where("Job No." = field("Job No."),
                                                                            "Job Task No." = field("Job Task No."),
                                                                            "Job Task No." = field(filter(Totaling)),
                                                                            "Schedule Line" = const(true),
                                                                            "Planning Date" = field("Planning Date Filter")));
            Caption = 'Budget (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50102; "4HC Usage (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Job Ledger Entry"."Total Cost" where("Job No." = field("Job No."),
                                                                           "Job Task No." = field("Job Task No."),
                                                                           "Job Task No." = field(filter(Totaling)),
                                                                           "Entry Type" = const(Usage),
                                                                           "Posting Date" = field("Posting Date Filter")));
            Caption = 'Actual (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50103; "4HC Contract (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Job Planning Line"."Line Amount" where("Job No." = field("Job No."),
                                                                             "Job Task No." = field("Job Task No."),
                                                                             "Job Task No." = field(filter(Totaling)),
                                                                             "Contract Line" = const(true),
                                                                             "Planning Date" = field("Planning Date Filter")));
            Caption = 'Billable (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50104; "4HC Contract (Invoiced Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = - sum("Job Ledger Entry"."Line Amount" where("Job No." = field("Job No."),
                                                                             "Job Task No." = field("Job Task No."),
                                                                             "Job Task No." = field(filter(Totaling)),
                                                                             "Entry Type" = const(Sale),
                                                                             "Posting Date" = field("Posting Date Filter")));
            Caption = 'Invoiced (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}