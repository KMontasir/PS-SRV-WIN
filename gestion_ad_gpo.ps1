### FONCTION #############################################################################

function f_choix_gpo {

    Write-Host "`n*** MENU GESTION UNITES D'ORGANISATIONS :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Afficher les GPO (Avec les principales informations)
    `n2 - Creer un rapport des GPO au format HTML (Dans un fichier recup_audit\gpo\GPO_audit.html)
    `n3 - Creer des rapports des GPO au format HTML (Dans plusieurs fichiers differents recup_audit\gpo\*.html)
    `n0 - Quitter `n"

    $choix   = Read-Host "`n*** Que voulez-vous faire ?"
    $domaine = Read-Host "`n*** Quel est le nom de domaine ? (domaine.local)"

    switch ($choix) {

        "1" {
            Get-GPO -All -Domain $domaine |
                Select-Object DisplayName, Id, Description, CreationTime
        }

        "2" {
            Get-GPOReport -All -ReportType Html -Path ".\recup_audit\gpo\GPO_audit.html"
        }

        "3" {
            # À compléter
        }

        "0" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
        }
    }

    f_choix_gpo
}

### PROGRAMME PRINCIPAL #################################################################


f_choix_gpo
