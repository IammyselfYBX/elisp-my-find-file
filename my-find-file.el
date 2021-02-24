;;选中选项，需要引入一个包——ivy
(require 'ivy) ;;没有的话 use-package 安装
(defun my-find-file ()
  (interactive)
  (let* ((cmd "find . -type f -name '*.*'") ;;只想看到文件
	 (output_cmd (shell-command-to-string cmd))
	 (lines (split-string output_cmd "[\n\r]+"))
	 (selected_lines (ivy-read "Find file> " lines))
	 )  
    ;;打开文件
    ;;健壮性检查
    ;;如果是一个不存在的文件,不应该是新建一个而是查询是爱
    (when (and selected_lines (file-exists-p selected_lines))
    (find-file selected_lines))
    ))
