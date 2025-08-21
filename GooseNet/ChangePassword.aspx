<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="GooseNet.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>GooseNet - Change Password</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1f2937, #111827);
            color: white;
        }
        .glass-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
        }
        .btn-primary {
            background: #38bdf8; /* Tailwind's sky-400 */
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background: #0ea5e9; /* Tailwind's sky-500 */
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.4);
        }
        .input-glass {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
            padding: 12px 16px;
            border-radius: 12px;
            outline: none;
            transition: border-color 0.3s ease;
        }
        .input-glass:focus {
            border-color: #38bdf8; /* Tailwind's sky-400 */
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6 flex items-center justify-center min-h-screen">
        <div class="max-w-lg w-full">
            <h1 class="text-4xl md:text-5xl font-extrabold mb-8 text-center" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                Account Management
            </h1>

            <!-- Change Password Panel -->
            <div class="glass-panel p-6 md:p-8 rounded-3xl shadow-2xl">
                <h2 class="text-3xl font-bold mb-6 text-center">Change Password</h2>

                <div class="flex flex-col items-center space-y-6">
                    <!-- Display Server-Side Error Messages -->
                    <div class="text-center text-red-400">
                        <%ShowErrorMessages(); %>
                    </div>

                    <!-- Password Change Form -->
                    <form action="HandlePasswordChange.aspx" method="post" class="w-full flex flex-col items-center space-y-6">
                        <input name="newPassword" type="password" placeholder="New Password" class="input-glass w-full" />
                        <input name="passwordRepeat" type="password" placeholder="Repeat New Password" class="input-glass w-full" />
                        <button type="submit" id="submitBtn" class="btn-primary text-white font-semibold py-3 px-6 rounded-xl w-full">
                            Change Password
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
