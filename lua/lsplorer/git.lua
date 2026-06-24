local git = {}

local G = {}

function G.strip_status(filename)
  return filename:match("^[^%s]+")
end

git.strip_status = G.strip_status
return git
