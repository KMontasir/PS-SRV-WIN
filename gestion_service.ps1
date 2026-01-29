### FONCTION #############################################################################

function f_choix_gestion {

    Write-Host "`n*** MENU GESTION SERVICES :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Routage NAT
    `n2 - DNS
    `n3 - Active Directory
    `n4 - DHCP
    `n5 - IIS
    `n6 - FTP
    `n7 - DFS
    `n8 - WDS
    `n9 - Quitter `n"

    $choix = Read-Host "`n*** Quel service voulez-vous gerer ?"

    switch ($choix) {

        "1" { .\gestion_nat.ps1 }
        "2" { .\gestion_dns.ps1 }
        "3" { .\gestion_ad.ps1 }
        "4" { .\gestion_dhcp.ps1 }
        "5" { .\gestion_iis.ps1 }
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