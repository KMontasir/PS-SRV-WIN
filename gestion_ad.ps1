### FONCTION #############################################################################

function f_choix_gestion {

    Write-Host "`n*** MENU GESTION ACTIVE DIRECTORY :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Afficher les principals informations de d'Active Directory
    `n2 - Gestion des unites d'organisations
    `n3 - Gestion des groupes
    `n4 - Gestion des utilisateurs
    `n5 - Gestion des GPO
    `n9 - Quitter `n"

    $choix = Read-Host "`n*** Quel service voulez-vous gerer ?"

    switch ($choix) {

        "1" { .\gestion_ad_info.ps1 }
        "2" { .\gestion_ad_ou.ps1 }
        "3" { .\gestion_ad_groupe.ps1 }
        "4" { .\gestion_ad_user.ps1 }
        "5" { .\gestion_ad_gpo.ps1 }
        "6" { .\gestion_ftp.ps1 }
        "7" { .\gestion_dfs.ps1 }
        "8" { .\gestion_wds.ps1 }
        "9" { exit }

        default {
            Write-Warning "Erreur de choix !"
            f_choix_gestion
        }
    }
}


### PROGRAMME PRINCIPAL #################################################################


f_choix_gestion