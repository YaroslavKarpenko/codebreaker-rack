# frozen_string_literal: true

require 'securerandom'
FILE_NAME = 'session_id.yml'
STORAGE_PATH = 'lib/models/session_id'

module SessionData
  def save_game_session(session)
    store = create_store_file file_path
    sid = generate_sid
    store_transaction(store, sid, session)
    sid
  end

  def load_game_session(sid)
    create_storage unless storage_exists?
    (load_file(file_path) || {})[sid]
  end

  private

  def create_store_file(path)
    YAML::Store.new(path)
  end

  def generate_sid
    SecureRandom.hex(16)
  end

  def store_transaction(store, session_id, session)
    store.transaction do
      store[session_id] = session
    end
  end

  def create_storage
    create_directory
    write_to_file file_path
    load_file file_path
  end

  def create_directory
    Dir.mkdir(STORAGE_PATH) unless Dir.exist?(STORAGE_PATH)
  end

  def write_to_file(path)
    File.open(path, 'w+') unless File.exist?(path)
  end

  def load_file(path)
    YAML.load_file(path)
  end

  def storage_exists?
    Dir.exist?(STORAGE_PATH) && File.exist?(file_path)
  end

  def file_path
    File.join(STORAGE_PATH, FILE_NAME)
  end
end
