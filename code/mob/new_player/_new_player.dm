mob/new_player
	var/character_created = FALSE
	var/datum/cosmetic/hair_style/_hair_style
	anchored = 2

mob/new_player/Login()
	..()
	if(loadCharacter())
		return
	showCharacterCreation(src)

mob/new_player/proc/saveCharacter()
	var/datum/save_data/SD = new
	SD.char_name = name
	SD.save(src)

mob/new_player/proc/loadCharacter()
	var/datum/save_data/SD = new
	if(SD.load(src))
		var/mob/living/human/H = new /mob/living/human(loc)
		H.name = SD.char_name
		H.client = client
		character_created = TRUE
		zDel(src)
		return TRUE
	return FALSE

mob/new_player/proc/deleteCharacter()
	var/datum/save_data/SD = new
	SD.delete_save(src)
	character_created = FALSE
	showCharacterCreation(src)

mob/new_player/proc/showCharacterCreation(mob/M)
	var/hair_style_options = ""

	for(var/style_type in subtypesof(/datum/cosmetic/hair_style))
		var/datum/cosmetic/hair_style/style = new style_type
		var/icon_id = "hair_style_[style.icon_state].png"
		M.client << browse_rsc(icon(style.icon,style.icon_state), icon_id)
		hair_style_options += "<option value='\ref[style]' data-icon-id='[icon_id]'>[style.name]</option>\n"
	M.client << browse_rsc(icon('human.dmi'), "human.png")
	var/character_creation_html = {"
	<html>
		<head>
			<title>Character Creation</title>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<style>
				body, html {
				margin: 0;
				padding: 0;
				width: 100%;
				height: 100%;
				background: #f4f4f0 url('paper_texture.jpg') repeat;
				font-family: 'Courier New', Courier, monospace;
				color: #333;
			}

			.container {
				display: flex;
				justify-content: center;
				align-items: center;
				height: 100%;
			}

			.char-creation-form {
				background-color: rgba(255,255,255,0.8);
				padding: 20px;
				border-radius: 5px;
				box-shadow: 0 0 10px rgba(0,0,0,0.5);
				border: 1px solid #d3d3d3;
				font-size: 16px;
			}

			select, input\[type="text"\], input\[type="submit"\] {
				padding: 10px;
				margin-bottom: 10px;
				border-radius: 5px;
				border: 1px solid #aaa;
				background-color: #eee;
				width: calc(100% - 22px);
				font-family: 'Courier New', Courier, monospace;
				box-shadow: inset 0 0 5px rgba(0,0,0,0.2);
			}

			.image-preview-container {
				position: relative;
				width: 100px;
				height: 100px;
				margin: auto;
				background-color: #eee;
				border: 1px solid #ccc;
				margin-bottom: 10px;
				box-shadow: 0 0 5px rgba(0,0,0,0.2);
			}

			.image-preview-container img {
				position: absolute;
				top: 0;
				left: 0;
				width: 100%;
				height: 100%;
				image-rendering: optimizeSpeed;             /* STOP SMOOTHING, GIVE ME SPEED  */
				-ms-interpolation-mode: nearest-neighbor;   /* IE8+                           */
			}

			#hair_style_preview {
				z-index: 2;
			}

			#human_icon {
				z-index: 1;
			}
			</style>
			<script>
				function updateHairStylePreview() {
					var select = document.getElementsByName('hair_style')\[0\];
					var selectedOption = select.options\[select.selectedIndex\];
					var iconId = selectedOption.getAttribute('data-icon-id');

					document.getElementById('hair_style_preview').src = iconId;
					document.getElementById('iconId').innerText = iconId;
				}

				document.addEventListener('DOMContentLoaded', function() {
					updateHairStylePreview();
				});
			</script>
		</head>
		<body>
			<div class="container">
				<div class="char-creation-form">
					<form action='byond://' method='get'>
						<input type='hidden' name='src' value='\ref[src]' />
						<input type='hidden' name='createCharacter' value='settings' />
						Character Name: <input type='text' name='char_name'><br>
						Hair Style: <select name='hair_style' onchange='updateHairStylePreview()'>[hair_style_options]</select><br>

						<div class="image-preview-container">
							<img id='human_icon' src='human.png'>
							<img id='hair_style_preview'>
						</div>
						<input type='submit' value='Create Character'>
						<div id='iconId'/>
					</form>
				</div>
			</div>
		</body>
	</html>"}
	M << browse(character_creation_html, "window=char_creation;size=400x500")
	winset(M.client, "char_creation", "border=0;titlebar=0")

mob/new_player/Topic(href, href_list)
	if(href_list["createCharacter"] == "settings")
		world << href
		var/mob/new_player/SRC = src

		var/char_name = href_list["char_name"]
		var/datum/cosmetic/hair_style/selected_style = locate(href_list["hair_style"])

		src._hair_style = selected_style

		src << browse(null, "window=char_creation")

		var/mob/living/human/H = new /mob/living/human()

		H.name = char_name
		H.hair_style = selected_style

		H.client = src.client

		src.character_created = TRUE

		zDel(SRC)
		return TRUE