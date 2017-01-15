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
            <!-- 1. row start -->
            <div class="row">
                <div class="col-sm-3">
                    <asp:Label runat="server" Text="Izberi uporabnika: "></asp:Label>
                </div>
                <div class=col-sm-3">
                    <asp:Button ID="deleteUser" Text="Izbrisi uporabnika" CssClass="col-sm-2 btn btn-primary gumb deleteUser" runat="server" OnClick="DeleteUser_Click"/>
                </div>
                <div class="col-sm-4">
                    <asp:DropDownList ID="Uporabniki" runat="server" AutoPostBack="true" AppendDataBoundItems="True">
                        <asp:ListItem>-- Izberi uporabnika --</asp:ListItem>
                    </asp:DropDownList>        
                </div>
                <div class="col-sm-3">
                    <asp:Label ID="izbraniUporabnik" runat="server" Text="Izbrani uporabnik: "></asp:Label>
                </div>
            </div>
            <!-- 1. row end --> 
            
            <!-- 2. row start -->
            <div class="row">
                <div class="col-sm-4">
                    <asp:Label runat="server" ID="stSporocil" Text="Stevilo sporocil: "></asp:Label>
                </div>
            </div>
            <!-- 2. row end -->
            
            <!-- 3. row start -->
            <div class="row">
                <div class="col-sm-3">
                    <asp:Label runat="server" Text="Je administrator: "></asp:Label>
                </div>
                <div class="col-sm-4">
                     <asp:DropDownList ID="IsAdminList" runat="server" AutoPostBack="true"></asp:DropDownList> 
                </div>
                <div class=col-sm-6">
                    <asp:Button ID="MakeAdmin" Text="Administrator" CssClass="col-sm-2 btn btn-primary gumb setAdmin" runat="server" OnClick="MakeAdmin_Click"/>
                </div>
            </div>
            <!-- 3. row end -->
            
            <!-- 4. row start -->
            <div class="row">
                <div class=col-sm-6">
                    <asp:Button ID="LogoutAdmin" Text="Odjava" CssClass="col-sm-2 btn btn-primary gumb odjava" runat="server" OnClick="LogoutAdmin_Click"/>
                </div>
            </div>
            <!-- 4. row end -->
        </form>
        
        <asp:Label runat="server" id="test" Text=""></asp:Label>
    </div>
</body>
</html>
