#! /usr/bin/env python
# -*- coding: utf-8 -*-

"""
u为老用户自动同步新的plist，不改变已有的entry设置.
"""

import sys, os
import plistlib

PLIST_REMOTE_SUB_PATH = 'Products/Debug/WeChatPlugin.framework/Resources/TKRemoteControlCommands.plist'
PLIST_LOCAL_PATH = os.path.expanduser('~') + '/Library/Containers/com.tencent.xinWeChat/Data/Documents/TKWeChatPlugin/'

def ExportPlistToDict(plist, key):
    plist_dic = {}
    for l1 in plist:
        for l2 in l1:
            plist_dic[l2[key]] = l2
    return plist_dic

def SyncPlistContent(remote_plist, local_plist, key):
    local_plist_dic = ExportPlistToDict(local_plist, key)

    new_tmp_plist = []
    for l1 in remote_plist:
        new_tmp_plist.append([])
        for l2 in l1:
            if l2[key] in local_plist_dic:
                new_tmp_plist[-1].append(local_plist_dic[l2[key]])
            else:
                new_tmp_plist[-1].append(l2)

    return new_tmp_plist

def main():
    root_path = os.path.dirname(os.path.abspath(sys.argv[0])) + '/'
    PLIST_REMOTE_PATH = root_path + PLIST_REMOTE_SUB_PATH

    if not os.path.isfile(PLIST_REMOTE_PATH) or not os.path.exists(PLIST_LOCAL_PATH):
        print('Find plist failed... exit')
        return 1

    remote_plist = plistlib.readPlist(PLIST_REMOTE_PATH)

    for user in os.listdir(PLIST_LOCAL_PATH):
        user_plist_dir = os.path.join(PLIST_LOCAL_PATH, user, 'TKRemoteControlCommands.plist')
        if not os.path.isfile(user_plist_dir):
            continue

        local_plist = plistlib.readPlist(user_plist_dir)
        new_plist = SyncPlistContent(remote_plist, local_plist, 'function')
        plistlib.writePlist(new_plist, user_plist_dir)

    return 0

if __name__ == '__main__':
    main()
