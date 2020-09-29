--- wikiconfig.py.orig	2018-09-09 21:10:20.000000000 +0300
+++ wikiconfig.py	2020-09-29 23:53:00.402022000 +0300
@@ -45,7 +45,7 @@
     # If that's not true, feel free to just set instance_dir to the real path
     # where data/ and underlay/ is located:
     #instance_dir = '/where/ever/your/instance/is'
-    instance_dir = wikiconfig_dir
+    instance_dir = '/usr/local/www/wiki'
 
     # Where your own wiki pages are (make regular backups of this directory):
     data_dir = os.path.join(instance_dir, 'data', '') # path with trailing /
@@ -107,6 +107,7 @@
     # your user name. See HelpOnAccessControlLists for more help.
     # All acl_rights_xxx options must use unicode [Unicode]
     #acl_rights_before = u"YourName:read,write,delete,revert,admin"
+    acl_rights_before = u"Admin:read,write,delete,revert,admin"
 
     # This is the default ACL that applies to pages without an ACL.
     # Adapt it to your needs, consider using an EditorGroup.
