;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules (gnu) (gnu system nss))
(use-service-modules desktop)
(use-package-modules certs gnome)

(operating-system
 (host-name "tumashu")
 (timezone "Asia/Shanghai")
 (locale "zh_CN.UTF-8")

 ;; Assuming /dev/sdX is the target hard disk, and "my-root"
 ;; is the label of the target root file system.
 (bootloader (grub-configuration (device "/dev/sda")))

 (swap-devices '("/dev/sda5"))

 (file-systems (cons* (file-system
                       (device "my-root")
                       (title 'label)
                       (mount-point "/")
                       (type "ext4"))
                      (file-system
                       (device "my-home")
                       (title 'label)
                       (mount-point "/home")
                       (type "ext4"))
                      (file-system
                       (device "my-backup1")
                       (title 'label)
                       (mount-point "/mnt/backup1")
                       (type "ext4"))
                      (file-system
                       (device "my-backup2")
                       (title 'label)
                       (mount-point "/mnt/backup2")
                       (type "ext4"))
                      %base-file-systems))

 (users (cons (user-account
               (name "feng")
               (comment "Feng Shu")
               (group "users")
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video"))
               (home-directory "/home/feng"))
              %base-user-accounts))

 ;; This is where we specify system-wide packages.
 (packages
  (append (map specification->package
               '("gvfs" "nss-certs"
                 "font-wqy-zenhei"
                 "font-ubuntu"
                 "icecat"))
          %base-packages))

 ;; Add GNOME and/or Xfce---we can choose at the log-in
 ;; screen with F1.  Use the "desktop" services, which
 ;; include the X11 log-in service, networking with Wicd,
 ;; and more.
 (services (cons* (xfce-desktop-service)
                  %desktop-services))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
