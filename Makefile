# .PHONY 告诉 Make 这些不是文件名，而是命令
.PHONY: run test fmt lint check all clean client

# 1. 运行程序 (简化了那串长路径)
run:
	uv run uvicorn src.nexus_zero.main:app --host 0.0.0.0 --port 8000 --reload

# 2. 运行测试
test:
	uv run pytest

client:
	python3 -m http.server 8001 --directory tests

# 3. 自动格式化代码 (Ruff)
fmt:
	uv run ruff format .

# 4. 检查代码质量 (Lint)
lint:
	uv run ruff check .

# 5. 一键做所有检查 (提交代码前跑这个)
check: fmt lint test

# 6. 打标签发布 (触发 GitHub Actions CD)
# 用法: make release v=v0.1.0
release:
	git tag $(v)
	git push origin $(v)

# 7. 清理缓存文件
clean:
	rm -rf .pytest_cache
	rm -rf .ruff_cache
	find . -type d -name "__pycache__" -exec rm -rf {} +