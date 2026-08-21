#
# TODO: Clean up routing.
#
Rails.application.routes.draw do
  concern :tamplate_common do
    get 'orphaned_templates', on: :collection
  end

  concern :previewable do
    post 'preview', on: :collection
  end

  resources :global_issue_templates, except: [:edit], concerns: %i[tamplate_common previewable]

  # for project issue template
  resources :projects, only: [] do
    resources :issue_templates, except: [:edit], concerns: [:tamplate_common] do
      post 'set_pulldown', on: :collection
      get 'list_templates', on: :collection
    end

    resources :issue_templates_settings, only: [:edit], concerns: [:previewable] do
      patch 'edit', on: :collection
    end

    get 'issue_templates_settings', to: 'issue_templates_settings#index'

    resources :note_templates, except: [:edit]
  end

  # R7/Rails 8.1: `only:` must list standard REST actions only. These blocks exist
  # solely to add the custom collection routes below (+ the previewable concern), so
  # they generate NO REST routes -> only: []. (Custom actions in only: were a no-op
  # pre-R7 and now raise.) refs #108530.
  resources :issue_templates, only: [], concerns: [:previewable] do
    post 'load', on: :collection
    get 'load_selectable_fields', on: :collection
  end

  # for note temlate
  resources :note_templates, only: [] do
    post 'load', on: :collection
    get 'list_templates', on: :collection
  end

  # for global note temlate
  resources :global_note_templates, except: [:edit], concerns: %i[previewable]
end
