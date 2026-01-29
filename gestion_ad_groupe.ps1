### FONCTION #############################################################################


function f_create_groupe {
    $nom_groupe = Read-Host "`nEntrez le groupe à creer (ex: groupe1)"
    $scope = Read-Host "Entrez le GroupScope (ex: Global) `n"
    $category = Read-Host "`nEntrez le GroupCategory (ex: Security)"

    New-ADGroup -Name $nom_groupe -GroupScope $scope -GroupCategory $category 
}


function f_create_groupes_csv {
    $scope = Read-Host "`nEntrez le GroupScope (ex: Global)"
    $category = Read-Host "`nEntrez le GroupCategory (ex: Security)"
    $CSVFile = ".\csv\ad_create_groupes.csv"
    $CSVData = Import-CSV -Path $CSVFile -Encoding UTF8

    Foreach($Groupes in $CSVData){

        $nom_groupe = $Groupes.Groupes
        # Vérifier la présence du groupe dans l'AD
        if (Get-ADGroup -Filter {Name -eq $nom_groupe})
        {Write-Warning "Le groupe $nom_groupe existe déjà dans l'AD"}
        else
            {New-ADGroup -Name $nom_groupe -GroupScope $scope -GroupCategory $category}
    }
}


function f_groupe {

    Write-Host "`n*** MENU GESTION GROUPES :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Afficher les groupes
    `n2 - Creer un seul groupe
    `n3 - Creer plusieurs groupes (fichier csv\groupes.csv)
    `n4 - Afficher les groupes vides
    `n5 - Quitter"

    $choix = Read-Host "Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            Get-ADGroup -Filter * |
                Select-Object SamAccountName, SID, DistinguishedName
        }

        "2" {
            f_create_groupe
        }

        "3" {
            f_create_groupes_csv
        }

        "4" {
            Get-ADGroup -Filter * -Properties Members |
                Where-Object { -not $_.Members } |
                Select-Object Name
        }

        "5" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
            f_groupe
        }
    }

    f_groupe
}



### PROGRAMME PRINCIPAL #################################################################


f_groupe