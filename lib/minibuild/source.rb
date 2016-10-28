module Minibuild
  class Source
    attr_reader :repo_url, :branch
    def initialize(repo_url, branch)
      @repo_url = repo_url
      @branch = branch
      make_or_open_repo
    end

    def make_or_open_repo
      if File.exist?(File.join(working_dir, '.git'))
        @git = Git.open(working_dir)
      else
        FileUtils.mkdir_p(working_dir)
        @git = Git.clone(repo_url, working_dir)
      end
    end

    # TODO: use PStore for storing info about already taken commits
    def fetch_and_export
      @git.fetch
      @git.branch(branch).merge("origin/#{target}") if @git.is_branch?(branch)
      export_code!
    end

    private

    def export_code!
      @git.object(branch).archive(output_file, format: 'tar', add_gzip: true)
    end

    def default_branch
      @default_branch ||= 'master'
    end

    def path
      File.join(Minibuild.projects_dir, name)
    end

    def working_dir
      File.join(path, 'scm')
    end

    def output_file
      sha = @git.object(branch).sha
      File.join(path, 'compressed', "#{sha}.tar.gz")
    end
  end
end
