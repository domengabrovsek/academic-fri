<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminPage.aspx.cs" Inherits="NoDB.AdminPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Page</title>
    <link rel="stylesheet" type="text/css" href="bootstrap-theme.min.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="bootstrap.min.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="AdminPanel.css" media="screen" />
    <script src="bootstrap.min.js" type="text/javascript"></script>
    <script src="jQuery.min.js" type="text/javascript"></script>
</head>
<body>

    <div id="admin-page">
        <h1>Administrator Menu</h1>
        <form class="form" runat="server">
            <div class="row">
                <div class="col-sm-3">
                    <asp:Label runat="server" Text="Izberi uporabnika: "></asp:Label>
                </div>
                <div class=col-sm-4">
                    <asp:Button ID="DeleteUser" Text="Izbrisi uporabnika" CssClass="col-sm-3 btn btn-primary gumb" runat="server" OnClick="DeleteUser_Click"/>
                </div>
                <div class=col-sm-4">
                    <asp:Button ID="SetAdmin" Text="Nastavi za administratorja" CssClass="col-sm-4 btn btn-primary gumb" runat="server" OnClick="SetAdmin_Click"/>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-4">
                    <asp:DropDownList ID="Test" runat="server"></asp:DropDownList>        
                </div>
            </div>

            <div class="row"><div class="col-sm-12">&nbsp</div></div>

            <div class="row">
                <div class=col-sm-6">
                    <asp:Button ID="LogoutAdmin" Text="Odjava" CssClass="col-sm-2 btn btn-primary gumb odjava" runat="server" OnClick="LogoutAdmin_Click"/>
                </div>
            </div>
        </form>
    </div>
</body>
</html>
