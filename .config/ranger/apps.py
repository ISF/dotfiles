# -*- coding: utf-8 -*-

import ranger
from ranger.api.apps import *
from ranger.ext.get_executables import get_executables

class CustomApplications(Applications):
	def app_default(self, c):
		"""How to determine the default application?"""
		f = c.file

		if f.basename.lower() == 'makefile' and c.mode == 1:
			made = self.either(c, 'make')
			if made: return made

		if f.extension is not None:
			if f.extension in ('pdf', ):
				return self.either(c, 'zathura', 'apvlv')
			if f.extension == 'djvu':
				return self.either(c, 'evince')
			if f.extension in ('xml', ):
				return self.either(c, 'editor')
			if f.extension in ('html', 'htm', 'xhtml'):
				return self.either(c, 'luakit', 'chromium')
			if f.extension == 'swf':
				return self.either(c, 'luakit', 'chromium')
			if f.extension in ('swc', 'smc', 'sfc'):
				return self.either(c, 'zsnes')
			if f.extension in ('odt', 'ods', 'odp', 'odf', 'odg',
					'doc', 'xls'):
				return self.either(c, 'libreoffice', 'soffice', 'ooffice')

		if f.mimetype is not None:
			if INTERPRETED_LANGUAGES.match(f.mimetype):
				return self.either(c, 'edit_or_run')

		if f.container:
			return self.either(c, 'xarchiver')

		if f.video or f.audio:
			if f.video:
				c.flags += 'd'
			return self.either(c, 'mplayer2', 'mplayer', 'vlc')

		if f.image:
			if c.mode in (11, 12, 13, 14):
				return self.either(c, 'set_bg_with_feh')
			else:
				return self.either(c, 'viewnior', 'feh')

		if f.document or f.filetype.startswith('text') or f.size == 0:
			return self.either(c, 'editor')

		# You can put this at the top of the function and mimeopen will
		# always be used for every file.
		return self.either(c, 'mimeopen')


	# ----------------------------------------- application definitions
	# Note: Trivial application definitions are at the bottom
	def app_pager(self, c):
		return 'less', '-R', c

	def app_editor(self, c):
		try:
			default_editor = os.environ['EDITOR']
		except KeyError:
			pass
		else:
			parts = default_editor.split()
			exe_name = os.path.basename(parts[0])
			if exe_name in get_executables():
				return tuple(parts) + tuple(c)

		return self.either(c, 'vim', 'emacs', 'nano')

	def app_edit_or_run(self, c):
		if c.mode is 1:
			return self.app_self(c)
		return self.app_editor(c)

	@depends_on('mplayer')
	def app_mplayer(self, c):
		if c.mode is 1:
			return 'mplayer', '-fs', c

		elif c.mode is 2:
			args = "mplayer -fs -sid 0 -vfm ffmpeg -lavdopts " \
					"lowres=1:fast:skiploopfilter=all:threads=8".split()
			args.extend(c)
			return args

		elif c.mode is 3:
			return 'mplayer', '-mixer', 'software', c

		else:
			return 'mplayer', c

	@depends_on('mplayer2')
	def app_mplayer2(self, c):
		args = list(self.app_mplayer(c))
		args[0] += '2'
		return args

	# A dependence on "X" means: this programs requires a running X server!
	@depends_on('feh', 'X')
	def app_set_bg_with_feh(self, c):
		c.flags += 'd'
		arg = {11: '--bg-scale', 12: '--bg-tile', 13: '--bg-center',
				14: '--bg-fill'}
		if c.mode in arg:
			return 'feh', arg[c.mode], c.file.path
		return 'feh', arg[11], c.file.path

	@depends_on('feh', 'X')
	def app_feh(self, c):
		c.flags += 'd'
		if c.mode is 0 and len(c.files) is 1: # view all files in the cwd
			images = [f.basename for f in self.fm.env.cwd.files if f.image]
			return 'feh', '--start-at', c.file.basename, images
		return 'feh', c

	@depends_on('make')
	def app_make(self, c):
		if c.mode is 0:
			return "make"
		if c.mode is 1:
			return "make", "install"
		if c.mode is 2:
			return "make", "clear"

	@depends_on('java')
	def app_java(self, c):
		def strip_extensions(file):
			if '.' in file.basename:
				return file.path[:file.path.index('.')]
			return file.path
		files_without_extensions = map(strip_extensions, c.files)
		return "java", files_without_extensions

	@depends_on('mimeopen')
	def app_mimeopen(self, c):
		if c.mode is 0:
			return "mimeopen", c
		if c.mode is 1: 
			# Will ask user to select program
			# aka "Open with..."
			return "mimeopen", "--ask", c


CustomApplications.generic('wine', 'zsnes', deps=['X'])

CustomApplications.generic('firefox', 'apvlv', 'zathura', 'gimp', 'viewnior', 'luakit'
			flags='d', deps=['X'])

INTERPRETED_LANGUAGES = re.compile(r'''
	^(text|application)/x-(
		haskell|perl|python|ruby|sh|lua
	)$''', re.VERBOSE)
