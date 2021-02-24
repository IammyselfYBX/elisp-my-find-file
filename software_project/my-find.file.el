;;选中选项，需要引入一个包——ivy
(require 'ivy) ;;没有的话 use-package 安装
(defun my-find-file-internal (directory)
  "Find file in DIRECTORY" ;;Emacs传统就是变量名在注释是大写
  (let* ((cmd "find .                       \
               -path '*/.git' -prune        \
               -o                           \
               -path '*/.ccls-cache' -prune \
               -o                           \
               -print                       \
               -type f                      \
               -name '*.*' ")
	 ;;但是打开其他文件默认的文件夹就会改变
	 ;;也不能每次都这么去做需要完善
	 ;;            ——locate-dominating-file来找目录
	 ;;这里使用 default-directory 的目的是递归调用，
	 ;; default-directory 每次都会更新自己
	 ;;假定都有 .git/吧,但是要求默认使用git管理，还好我自己都会使用git
	 ;;	 (default-directory (locate-dominating-file default-directory ".git"))
	 (default-directory directory)
	 ;;需要放到这里，可能是因为会被重新刷新
	 
	 ;;只想看到文件
	 ;;这个 . 多余 使用 cdr 去除
	 (output_cmd (shell-command-to-string cmd))
	 (lines (cdr (split-string output_cmd "[\n\r]+")))

	 ;;更加友好一些——提示目录
	 (selected_lines
	  (ivy-read
	   (format "Find file in %s> "
		   default-directory)
	           lines)
         ))
    ;;打开文件
    ;;健壮性检查
    ;;如果是一个不存在的文件,不应该是新建一个而是查询是爱
    (when (and selected_lines (file-exists-p selected_lines))
    (find-file selected_lines))
    ))

(defun my-find-file-in-project()
  "Find file in project root directory"
  (interactive) ;;实现交互
  (my-find-file-internal (locate-dominating-file default-directory ".git"))
  )

(defun my-find-file()
  "Find file in current directory"
  (interactive)
  (my-find-file-internal default-directory)
  )
