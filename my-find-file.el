;;选中选项，需要引入一个包——ivy
(require 'ivy) ;;没有的话 use-package 安装
(defun my-find-file ()
  (interactive)
  (let* ((cmd "find .                       \
               -path '*/.git' -prune        \
               -o                           \
               -path '*/.ccls-cache' -prune \
               -o                           \
               -print                       \
               -type f                      \
               -name '*.*' ")
	 ;;但是打开其他文件默认的文件夹就会改变
	 ;;简单粗暴
	 (my-default-directory "~/practure/learn_linux-0.11")
	 ;;需要放到这里，可能是因为会被重新刷新
	 
	 ;;只想看到文件
	 ;;这个 . 多余 使用 cdr 去除
	 (output_cmd (shell-command-to-string cmd))
	 (lines (cdr (split-string output_cmd "[\n\r]+")))

	 ;;更加友好一些——提示目录
	 (selected_lines
	  (ivy-read
	   (format "Find file in %s> "
		   my-default-directory)
	           lines)
         ))
    ;;打开文件
    ;;健壮性检查
    ;;如果是一个不存在的文件,不应该是新建一个而是查询是爱
    (when (and selected_lines (file-exists-p selected_lines))
    (find-file selected_lines))
    ))
