
=======================================================================

			HOW TO COMPILE IT

=======================================================================

Prerequisites
------------------------

 NME should be installed on your system in order to compile and should be
 setup according to targeted platform (IOS, Android and Flash)


Steps for compiling
------------------------

 1. Resizing all assets according to resolution.

	a. Go to deploy directory

	b. Compile the Deploy.java program by running the following:

		# Use (:) instead of (;) in b. if on *nix/Solaris.
		javac -cp .;imgscalr.jar Deploy.java


	c. execute command

		# Use (:) instead of (;) in b. if on *nix/Solaris.
		java -cp .;imgscalr.jar Deploy "width" "height"

		# (where width and height will be resolution in landscape mode.)

		Use dimensions (1920, 1200), as the code scales the assets assuming
		the original assets were for this dimension.



 2. Compiling it for testing

	Go back to the root directory if not already there

	For compiling it execute command

		nme test application.nmml target

	Where target can be:
	  a. ios (to run in simulator add `-simulator` at the end of the command)
	  b. android
	  c. flash

