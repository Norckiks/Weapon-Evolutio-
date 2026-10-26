# Tests Studio uniquement

## Fusil à pompe

Dans une session Play neuve SessionStudio, créer FirearmsQABridge et installer FirearmsBridge.client.luau côté Client. Exécuter d'abord Firearms.server.luau (33 régressions), puis Shotgun.server.luau (30 contrôles, chargeur du fusil encore neuf), puis ShotgunKill.server.luau (cinq contrôles et vraie mort Civilian). Lire les StringValue FirearmsQAResult, ShotgunQAResult et ShotgunKillQAResult dans ServerStorage. Un seul harnais à la fois. Après préparation d'un personnage démarré/équipé avec un chargeur plein, ShotgunPresentation.client.luau attend un vrai clic de tir pendant 90 s, puis teste pompe, effets et deux recharges. Lire PlayerGui.ShotgunPresentationQAResult. Son compteur final comprend trois tirs (un natif, deux remotes de test), dont un muet ; ses assertions intermédiaires vérifient un événement/flash/son et sept traceurs pour le premier tir.

Fixtures temporaires uniquement, arrêter Play après tous les essais même en cas d'échec. Les achats des harnais passent par le service économique ; l'achat par clic PC et TIR simulé ont été vérifiés séparément. Rapport shotgun-result.json. Aucun test production ou tactile/manette physique.

## Dossiers d'expédition

Créer ExpeditionsQABridge (RemoteFunction) dans ReplicatedStorage serveur Play. Installer ExpeditionsBridge.client.luau dans PlayerScripts côté Client, puis Expeditions.server.luau comme Script serveur temporaire. Lire ServerStorage.ExpeditionsQAResult jusqu'au JSON final. Le harnais modifie le profil temporaire, attribue un décès à un vrai zombie et teste douze réclamations par le vrai remote client ; il restaure ensuite le profil. Arrêter Play même en cas d'échec. Résultats et captures inspectées décrits dans expeditions-result.json et docs/reference/EXPEDITIONS.md. La sérialisation JSON n'est pas un test de reconnexion DataStore.

Coordonnées d'entrée : la correction d'origine ci-dessous est spécifique au téléphone simulé testé. Sur PC, le centre absolu sans cette correction a fonctionné pour le bouton de dossier ; le centre corrigé n'a pas réclamé la récompense. Toujours vérifier le changement serveur, ne pas généraliser une seule formule à tous les simulateurs.

## Capacités et animations

Dans une session Play SessionStudio, installer temporairement Abilities.server.luau comme Script serveur. Attendre ReplicatedStorage.AbilitiesQAControl == "ReadyFrost", puis côté Client appeler UseAbility:FireServer("Frost", Vector3.new(0,0,-1)). Quand l'état passe à ReadyAegis, appeler UseAbility:FireServer("Aegis"). Le harnais mesure une cible à 58 studs, hors axe/hors portée, la garde pendant l'attaque et le retour des dégâts à son expiration. Lire ServerStorage.AbilitiesQAResult.

Pour le soin et la frappe, utiliser AbilityVisuals.server.luau, attendre ReadyHeal puis envoyer UseAbility:FireServer("SecondSouffle"); attendre ReadySlam, puis envoyer UseAbility:FireServer("Slam"). Lire ServerStorage.AbilityVisualsQAResult. Compter les instances d'effet dans Workspace.LocalPulseFX côté Client pendant leur courte durée : en rendu normal, le soin ajoute 12 étincelles et 8 segments de halo ; la frappe ajoute 12 fissures et 12 segments de vague. Ces deux harnais restaurent le niveau, les PV et le pivot ; arrêter Play après lecture des résultats. Ils ne doivent jamais être installés en Edit.

## Onde de choc et coordonnées du simulateur

Créer PulseQABridge (RemoteFunction) dans ReplicatedStorage côté serveur Play, puis installer PulseBridge.client.luau comme LocalScript temporaire dans PlayerScripts **côté Client**. Installer Pulse.server.luau comme Script serveur temporaire et lire ServerStorage.PulseQAResult jusqu'au JSON final. Ce harnais utilise une vraie réapparition, des cibles factices et de vrais zombies ; il respecte le délai privé existant au lieu de le réinitialiser. Restaurer les options, puis arrêter Play même en cas d'échec. Aucun de ces fichiers n'est installé en Edit.

Pour les clics automatiques sur un téléphone simulé, le centre AbsolutePosition + AbsoluteSize/2 peut inclure une origine de ScreenGui décalée (ici Y=-58). Le ciblage par instance_path n'a pas atteint le bouton pendant ces essais. Les coordonnées qui ont fonctionné sont : **centre absolu du bouton − AbsolutePosition du ScreenGui ancêtre**, envoyées explicitement à moveTo, avec attente puis mouseButtonDown/attente/mouseButtonUp. Confirmer Activated ou la transition serveur ; « Success » du seul outil ne prouve pas le clic.

Le verrouillage de souris de la vue subjective peut nécessiter, pour le test souris en émulation mobile, une libération temporaire après Camera. Cette fixture doit être retirée ; ne pas modifier les contrôles mobiles du jeu pour compenser l'outil. Le clic portrait ONDE a été confirmé avec FistsPunch d'origine. Le clic Jouer a été confirmé depuis un menu préparé, pas comme essai physique ou démarrage initial sans fixture. Résultats pulse-result.json.

## Extension du port

Harbor.server.luau est un Script serveur temporaire SessionStudio : contrôles de scène/spawns, accès 19/20, vrais callbacks de morts avec dégâts létaux attribués par le test, fragments et fusion, bonus et réapparition. HarborCombat.server.luau exige le pont Firearms côté Client et sa RemoteFunction : tirs réels dans le port, recharge et récompenses d'un matelot. Il ancre temporairement les racines des zombies du port et restaure leurs états ; arrêter Play après le test, y compris en cas d'échec. Résultats ServerStorage.HarborQAResult et HarborCombatQAResult. Consulter harbor-result.json pour les preuves obtenues et les limites.

Ne jamais installer ces fichiers en Edit ou les publier. Exécuter un seul harnais à la fois sur un joueur Studio chargé, avec PersistenceMode=SessionStudio. Ils modifient temporairement inventaire, monnaie, personnage et état de menu. Arrêter Play à la fin même en cas d'échec.

## Armes

Le harnais Firearms couvre maintenant Pistolet, SMG et Revolver (33 contrôles dans revolver-result.json). Après préparation d'un personnage démarré et équipé du revolver en SessionStudio, RevolverPresentation.client.luau peut être installé comme LocalScript temporaire dans PlayerScripts côté Client : il tire/recharge deux fois, échantillonne la pose réellement rendue et les étapes sonores, puis restaure ReducedMotion/SFXEnabled. Résultat PlayerGui.RevolverPresentationQAResult. Les munitions de session sont consommées puis rechargées ; arrêter Play après essai. Ne jamais installer ce sampler en Edit.

1. Partir d'une session Play neuve : les chargeurs sont propres à la session.

2. Créer en serveur Play une RemoteFunction nommée FirearmsQABridge dans ReplicatedStorage.

3. Installer temporairement FirearmsBridge.client.luau comme LocalScript dans PlayerScripts ; attendre sa liaison.

4. Installer Firearms.server.luau comme Script temporaire dans ServerScriptService.

5. Lire ServerStorage.FirearmsQAResult jusqu'à obtention du JSON final. Lire aussi la console si le résultat reste Running.

6. Arrêter Play pour supprimer le pont et les scripts temporaires. Le pont n'est pas un composant du jeu.

Le pont permet au harnais serveur de demander de vraies émissions client. RemoteEvent:FireServer ne fonctionne pas dans un Script serveur. La rafale est émise en un seul appel client, pour éviter que la latence des allers-retours transforme le test en tirs espacés.

## Autres harnais

Expansion.server.luau, Movement.server.luau et Contracts.server.luau s'exécutent en Script serveur temporaire. Leurs résultats sont respectivement ExpansionQAResult, MovementQAResult et ContractsQAResult dans ServerStorage. Attendre la fin et la restauration de chaque harnais avant de lancer le suivant.

Les résultats JSON sont datés et limités à leur scénario. Ils ne prouvent pas le rendu visuel, le multijoueur, la persistance réelle ni la fluidité sur toutes les cartes/appareils. Le nombre de contrôles Expansion peut varier avec les fragments aléatoires inspectés.

## Séries d'éliminations

Pour connaître les différences actuelles entre disque et Studio, lire handoff-audit-latest.json : les 40 scripts correspondent désormais aux fichiers locaux, y compris Expeditions. Les audits datés antérieurs sont historiques.

## Terrain et guide de zone

TerrainMovementBridge.client.luau se lie à une RemoteFunction temporaire TerrainMovementQABridge dans ReplicatedStorage. TerrainVaults.server.luau demande de vrais FireServer client sur cinq obstacles permanents, ou huit lorsque le port existe. Installer uniquement en Play de test et lire TerrainVaultsQAResult dans ServerStorage. Le pont est détruit à la fin du harnais : pour répéter, recréer la RemoteFunction et son LocalScript client. TerrainLocomotion.server.luau porte un attribut ZoneId (City/Factory/Lab/Harbor) ; après TerrainLocomotionReady, piloter immédiatement avec Maj+W, C puis Ctrl après la glissade. Lancer le sampler et les entrées dans une seule séquence d'outils pour éviter de dépasser sa fenêtre de mesure. Relâcher toutes les touches avant un autre harnais. Résultat TerrainLocomotionQA_<Zone>. Arrêter Play ensuite.

zone-guide-result.json conserve les états des guides et les mesures iPhone simulé paysage/portrait. Les captures montrent la flèche écran ; Enabled/Adornee du Billboard ne prouvent pas son rendu visible. Les niveaux de test sont réservés à SessionStudio. La console du dernier contrôle contenait seulement une assertion de fixture corrigée avant mutation, et ne doit pas être décrite comme vide.

KillChains.server.luau s'exécute en Script serveur temporaire après chargement du profil SessionStudio. Il attend les vraies échéances de huit secondes et tue/réapparaît le personnage de test. Lire ServerStorage.KillChainsQAResult. Il conserve puis restaure Meta, monnaie, XP, niveau, position et préférences de menu ; arrêter Play après lecture pour supprimer tous les effets temporaires. Les callbacks synthétiques vérifient le cycle du compteur, pas l'attribution d'une vraie élimination par ZombieDirector. Le résultat du 22 octobre est kill-chains-result.json. notification-layout-result.json couvre la passe UI ultérieure sur PC et téléphone simulé : gains/séries, fragments, boosts et munitions simultanés, avec mesures des rectangles et captures inspectées. pending-studio-sync.json est historique.

## Navigation souris M

mouse-navigation-result.json contient les 11 contrôles de la passe du 22 octobre. Pour reproduire les interactions, utiliser une session Studio PC neuve et les outils d'entrée utilisateur :

1. Cliquer JOUER, appuyer sur M ; vérifier MouseUnlocked=true, MouseUnlockButton.Modal=true, pointeur visible et MouseBehavior.Default pendant 30 images.

2. Cliquer Options : la fenêtre Options doit s'ouvrir, et non la boutique située plus bas. M reste inactif pendant ce menu ; sa fermeture remet le pointeur au centre.

3. En mode souris libre, maintenir le clic : aucun SwingAt serveur et aucune balle de pistolet ne doivent être consommés. Tester ensuite la reprise avec M.

4. Une sonde temporaire peut interrompre la préparation d'un coup par MouseUnlocked=true puis false après 20/30 ms ; vérifier que le son de préparation existe mais qu'aucune frappe différée n'arrive au serveur. Cette sonde est synthétique, distincte d'un essai humain de rapidité.

5. Réapparaître : le mode doit être réinitialisé. Configurer ensuite le téléphone simulé avant Play : bouton M masqué et modalité inactive, même après une touche M virtuelle.

Les profils utilisés doivent rester SessionStudio. L'armement temporaire du pistolet et la réapparition sont des fixtures ; arrêter Play après les contrôles. La libération du pointeur ne suspend pas le monde et ne change aucune validation serveur de combat.


## Panneau admin personnel
Dans une session Studio Play du compte autorisé, installer temporairement Admin.server.luau dans ServerScriptService. Lire ServerStorage.AdminQAResult ; le script restaure le profil même en cas d'échec. Arrêter Play après. Ne jamais installer en Edit. Résultat : admin-result.json ; limites et essais client dans docs/reference/ADMIN_PANEL.md.
