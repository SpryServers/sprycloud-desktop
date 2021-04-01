set( APPLICATION_NAME       "spryCloud" )
set( APPLICATION_SHORTNAME  "spryCloud" )
set( APPLICATION_EXECUTABLE "sprycloud" )
set( APPLICATION_DOMAIN     "www.spryservers.net" )
set( APPLICATION_VENDOR     "Spry Servers, LLC" )
set( APPLICATION_UPDATE_URL "https://updates.cloud.spryservers.net/" CACHE string "URL for updater" )
set( APPLICATION_HELP_URL   "" CACHE STRING "URL for the help menu" )
set( APPLICATION_ICON_NAME  "spryCloud" )
set( APPLICATION_ICON_SET   "SVG" )
set( APPLICATION_SERVER_URL "https://cloud.spryservers.net" CACHE STRING "URL for the server to use. If entered the server can only connect to this instance" )
set( APPLICATION_SERVER_URL_ENFORCE ON ) # If set and APPLICATION_SERVER_URL is defined, the server can only connect to the pre-defined URL
set( APPLICATION_REV_DOMAIN "net.spryservers.sprycloudclient" )

set( LINUX_PACKAGE_SHORTNAME "sprycloud" )
set( LINUX_APPLICATION_ID "${APPLICATION_REV_DOMAIN}.${LINUX_PACKAGE_SHORTNAME}")

set( THEME_CLASS            "NextcloudTheme" )

set( WIN_SETUP_BITMAP_PATH  "${CMAKE_SOURCE_DIR}/admin/win/nsi" )

set( MAC_INSTALLER_BACKGROUND_FILE "${CMAKE_SOURCE_DIR}/admin/osx/installer-background.png" CACHE STRING "The MacOSX installer background image")

# set( THEME_INCLUDE          "${OEM_THEME_DIR}/mytheme.h" )
# set( APPLICATION_LICENSE    "${OEM_THEME_DIR}/license.txt )

option( WITH_CRASHREPORTER "Build crashreporter" OFF )
#set( CRASHREPORTER_SUBMIT_URL "https://crash-reports.owncloud.com/submit" CACHE STRING "URL for crash reporter" )
#set( CRASHREPORTER_ICON ":/owncloud-icon.png" )

## Updater options
option( BUILD_UPDATER "Build updater" OFF )

option( WITH_PROVIDERS "Build with providers list" ON )


## Theming options
set( APPLICATION_WIZARD_HEADER_BACKGROUND_COLOR "#2cc76a" CACHE STRING "Hex color of the wizard header background")
set( APPLICATION_WIZARD_HEADER_TITLE_COLOR "#ffffff" CACHE STRING "Hex color of the text in the wizard header")
option( APPLICATION_WIZARD_USE_CUSTOM_LOGO "Use the logo from ':/client/theme/colored/wizard_logo.(png|svg)' else the default application icon is used" ON )


#
## Windows Shell Extensions & MSI - IMPORTANT: Generate new GUIDs for custom builds with "guidgen" or "uuidgen"
#
if(WIN32)
    # Context Menu
    set( WIN_SHELLEXT_CONTEXT_MENU_GUID      "{23837a05-b7a0-47aa-bfb4-b28b21c7ef1e}" )

    # Overlays
    set( WIN_SHELLEXT_OVERLAY_GUID_ERROR     "{297f0537-5d39-46bf-923c-1c8cbb52be20}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_OK        "{39292037-5f73-4375-983f-b0a65a5ab160}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_OK_SHARED "{5f172073-eb5a-457c-bf8f-e083d805df62}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_SYNC      "{b1cdf413-b928-412c-85a4-86eaf31c5ce7}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_WARNING   "{f70cc582-3bb5-4085-b01f-04b5afdc63b3}" )

    # MSI Upgrade Code (without brackets)
    set( WIN_MSI_UPGRADE_CODE                "744e985b-5afc-4db4-9934-7fec80b1c6d1" )

    # Windows build options
    option( BUILD_WIN_MSI "Build MSI scripts and helper DLL" OFF )
    option( BUILD_WIN_TOOLS "Build Win32 migration tools" OFF )
endif()
