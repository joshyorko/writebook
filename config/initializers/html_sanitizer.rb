Rails.application.config.action_view.sanitized_allowed_tags =
  Rails::HTML5::SafeListSanitizer.allowed_tags + %w[ center details iframe summary table tbody td tfoot th thead tr video ]

Rails.application.config.action_view.sanitized_allowed_attributes =
  Rails::HTML5::SafeListSanitizer.allowed_attributes + %w[ id style target ]
