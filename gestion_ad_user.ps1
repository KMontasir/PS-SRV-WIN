### FONCTION #############################################################################

function f_create_user {

    $domaine = Read-Host "Entrer le domaine (ex: domaine.local)"
    $nomUtilisateur = Read-Host "Entrer l'utilisateur à creer (ex: nom prenom)"
    $identifiant = Read-Host "Entrer l'identifiant de l’utilisateur à creer (ex: nom.prenom)"
    $mdp = Read-Host "Quel sera le mot de passe par defaut pour l'utilisateur ? (ex : Azerty/123)"

    New-ADUser -Name $nomUtilisateur -SamAccountName $identifiant -UserPrincipalName "${identifiant}@${domaine}" -AccountPassword (ConvertTo-SecureString -AsPlainText $mdp -Force) -CannotChangePassword $False -Enabled $true -ChangePasswordAtLogon $true
}


function f_create_users_csv {
    $domaine = Read-Host "Entrer le domaine (ex: domaine.local)"
    $CSVFile = ".\csv\ad_create_users.csv"
    $CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8
    $mdp = Read-Host "Quel sera le mot de passe par defaut pour les utilisateurs ? (ex : Azerty/123)"

    Foreach($Utilisateur in $CSVData){

        $prenom = $Utilisateur.Prenom
        $nom = $Utilisateur.Nom
        $identifiant = ($prenom).Substring(0,1) + "." + $nom

        # Vérifier la présence de l'utilisateur dans l'AD
        if (Get-ADUser -Filter {SamAccountName -eq $identifiant})
        {Write-Warning "L'identifiant $identifiant existe deja dans l'AD"}
        else
            {New-ADUser -Name "$nom $prenom" -SamAccountName $identifiant -UserPrincipalName $identifiant@$domaine -AccountPassword (ConvertTo-SecureString -AsPlainText $mdp -Force) -CannotChangePassword $true -Enabled $true -ChangePasswordAtLogon $true}
    }
}


function f_user {

    Write-Host "`n*** MENU GESTION UTILISATEURS :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Afficher les utilisateurs
    `n2 - Afficher les utilisateurs actives
    `n3 - Afficher les utilisateurs desactives
    `n4 - Afficher la derniere connexion des utilisateurs
    `n5 - Afficher la date de creation des utilisateurs
    `n6 - Afficher les informations d’expiration de mot de passe des utilisateurs
    `n7 - Creer un seul utilisateur
    `n8 - Creer plusieurs utilisateurs (fichier csv\ad_create_users.csv)
    `n9 - Quitter"

    $choix = Read-Host "Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            Get-ADUser -Filter * |
                Format-Table Name, UserPrincipalName, SID, DistinguishedName
        }

        "2" {
            Get-ADUser -Filter { Enabled -eq $True } |
                Format-Table SamAccountName, Name
        }

        "3" {
            Get-ADUser -Filter { Enabled -eq $False } |
                Format-Table SamAccountName, Name
        }

        "4" {
            Get-ADUser -Filter * -Properties LastLogonDate |
                Format-Table Name, SamAccountName, LastLogonDate, Enabled -Auto
        }

        "5" {
            Get-ADUser -Filter * -Properties whenCreated |
                Format-Table Name, UserPrincipalName, whenCreated
        }

        "6" {
            Get-ADUser -Filter * -Properties PasswordLastSet, PasswordNeverExpires |
                Format-Table Name, PasswordLastSet, PasswordNeverExpires
        }

        "7" {
            f_create_user
        }

        "8" {
            f_create_users_csv
        }

        "9" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
            f_user
        }
    }

    f_user
}


### PROGRAMME PRINCIPAL #################################################################


f_user