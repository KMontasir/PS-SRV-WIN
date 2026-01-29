##########################################################################################
#                                                                                        #
#                                                                                        #
#                    *** GESTIONNAIRE DE SERVEUR ACTIVE DIRECTORY ***                    #
#                                     (Version Beta)                                     #
#                                                                                        #
#                                  de KHOULKHALI MONTASIR                                #
#                                                                                        #
#                                                                                        #
##########################################################################################
#                                                                                        #
# DATE : 24/10/2023                                                                      #
#                                                                                        #
# VERSION : Beta                                                                         #
#                                                                                        #
# CONTACT : khoulkhali.montasir@gmail.com                                                #
#                                                                                        #
##########################################################################################


### FONCTION #############################################################################


function f_choix_programme {

    Write-Output "`n*** MENU PRINCIPAL :`n
    `n1 - Information du serveur
    `n2 - Configuration du serveur 
    `n3 - Installation de services
    `n4 - Gestion de services
    `n5 - Quitter `n"

    $choix = Read-Host "`n*** Quelle action voulez-vous exécuter ?"

    switch ($choix) {
        "1" { .\info.ps1 }
        "2" { .\config.ps1 }
        "3" { .\install_service.ps1 }
        "4" { .\gestion_service.ps1 }
        "5" { exit }
        default {
            Write-Warning "Erreur de choix !"
            f_choix_programme
        }
    }
}


### PROGRAMME PRINCIPAL #################################################################

Write-Host "
##########################################################################################
#                                                                                        #
#                                                                                        #
#                    *** GESTIONNAIRE DE SERVEUR ACTIVE DIRECTORY ***                    #
#                                     (Version Beta)                                     #
#                                                                                        #
#                                  de KHOULKHALI MONTASIR                                #
#                                                                                        #
#                                                                                        #
##########################################################################################
" -BackgroundColor Blue -ForegroundColor White 


f_choix_programme