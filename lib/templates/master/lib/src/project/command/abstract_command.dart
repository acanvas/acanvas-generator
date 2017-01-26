part of rockdot_template;

	 class AbstractCommand extends RdCommand implements IModelAware {
		 Model _appModel; 
		void set appModel(Model appModel) {
			_appModel = appModel;
		}

	}

