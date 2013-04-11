
=======================================================================

			HOW TO COMPILE IT 

=======================================================================

Prerequisites
------------------------

 NME should be installed on your system in order to compile and should be 
 setup according to targeted platform (IOS, Android and Flash)


Steps for compiling 
------------------------

 1. Resizing all assets according to resoltion.
	a. Go to deploy directory
	b. execute command  -  java -cp .;imgscalr.jar Delpoy "width" "height"

			where width and height will be resolution in landscape mode.

 Note: Use (:) instead of (;) in b. if on *nix/Solaris. Use dimensions (1920, 1200), as the code scales the assets assuming the original assets were for this dimension.

 2. Compiling it for testing 

	For compiling it execute command
		nme test application.nmml target

	Where target can be:
	  a. ios
	  b. android
	  c. flash

