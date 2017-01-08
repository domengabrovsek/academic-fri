<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="NoDB.Chat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="Login.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="bootstrap-theme.min.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="bootstrap.min.css" media="screen" />
    <script src="bootstrap.min.js" type="text/javascript"></script>
    <script src="jQuery.min.js" type="text/javascript"></script>
    <script src="myScript.js" type="text/javascript"></script>
</head>
<body>
    <div class="login-page">
        <form class="form-horizontal form" runat="server">

            <!-- Registration form --> 
            <div id="registration-form">
                <!-- Title -->
                <div class="row">  
                    <div class="col-sm-offset-4 col-sm-5">
                        <h3>Registracija</h3>
                        <p class="italic"> &nbsp&nbsp Novi uporabniki</p>
                    </div> 
                </div> 
                <!-- Name -->
                <div class="form-group">
                    <label for="Name" class="col-sm-4 control-label">Ime:</label>
                    <div class="col-sm-6"><input type="text" class="form-control" id="Name" runat="server"/></div>  
                </div>
                <!-- Surname -->
                <div class="form-group">
                    <label for="Surname" class="col-sm-4 control-label">Priimek:</label>
                    <div class="col-sm-6"><input type="text" class="form-control" id="Surname" runat="server"/></div>  
                </div>
                <!-- Username -->
                <div class="form-group">
                    <label for="Username" class="col-sm-4 control-label">Uporabniško ime:</label>
                    <div class="col-sm-6"><input type="text" class="form-control" id="Username" runat="server"/></div>  
                </div>
                <!-- Password -->
                <div class="form-group">
                    <label for="Password" class="col-sm-4 control-label">Geslo:</label> 
                    <div class="col-sm-4"><input type="password" class="form-control" id="Password" runat="server" placeholder=""/></div>  
                    <div class="col-sm-4"><asp:Label runat="server" ID="wrongPassword1" Text=""  CssClass="wrongPassword"></asp:Label></div>
                </div>
                <!-- Repeat password -->
                <div class="form-group">
                    <label for="PasswordRepeat" class="col-sm-4 control-label">Ponovi geslo:</label>
                    <div class="col-sm-4"><input type="password" class="form-control" id="PasswordRepeat" runat="server"/></div>  
                    <div class="col-sm-4"><asp:Label runat="server" ID="wrongPassword2" Text="" CssClass="wrongPassword"></asp:Label></div>
                </div>
                <!-- Login button -->
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <asp:Button ID="RegistrationBtn" Text="Registracija" CssClass="col-sm-offset-3 col-sm-6 btn btn-primary" runat="server" OnClick="RegistrationBtn_Click"/>
                        <div class="col-sm-10"><asp:Label runat="server" ID="RegistrationSuccess" Text=""  CssClass="RegistrationSuccess"></asp:Label></div>
                    </div>
                </div>
            </div>

            <!-- Login form -->
            <div id="login-form">
                 <!-- Title -->
                <div class="row">  
                    <div class="col-sm-offset-4 col-sm-5">
                        <h3 style="left:50px;
                                   position:relative;
                                   ">Prijava</h3>
                        <p class="italic"> &nbsp&nbsp Obstoječi uporabniki</p>
                    </div> 
                </div> 
                <!-- Username -->
                <div class="form-group">
                    <label for="LoginUsername" class="col-sm-4 control-label">Uporabniško ime:</label>
                    <div class="col-sm-6"><input type="text" class="form-control" id="LoginUsername" runat="server"/></div>  
                </div>
                <!-- Password -->
                <div class="form-group">
                    <label for="LoginPassword" class="col-sm-4 control-label">Geslo:</label>
                    <div class="col-sm-6"><input type="password" class="form-control" id="LoginPassword" runat="server"/></div>  
                </div>
                <!-- Login button -->
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-12">
                        <asp:Button ID="LoginBtn" Text="Prijava" CssClass="col-sm-offset-3 col-sm-4 btn btn-primary" runat="server" OnClick="LoginBtn_Click"/>
                    </div>
                </div>
            </div>
        </form>
    </div>
</body>
</html>
