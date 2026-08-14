pageextension 50113 BusinessManagerRoleCenter extends "Business Manager Role Center"
{
    actions
    {
        addafter("Bank Accounts")
        {
            action(ResourceAllocation)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Resource Allocation';
                RunObject = Page "Transport MatrixS365";
                ToolTip = 'Open a Resource Allocation Page';
            }
        }
    }
}
